class PpobPesawatController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :Authentication, except: [:pencarian_landing, :eticket_pdf]
  include ApplicationHelper
  include VariableHelper
  require 'helper/time'
  require 'helper/number'
  require 'helper/strg'

  def index
    @res = params['res']
    begin
        @bandara = Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
        @bandara_terdekat = Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
        @bandara_terdekatApi = Api::Account::TiketPesawatController.bandaraTerdekat(session[:acc_token], session[:tiket])
        @bandara_terdekat.unshift(@bandara_terdekatApi[0])
        # render json: @bandaraTerdekat

        render 'accounts/evoucher/tiket-pesawat/index'
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    
  end
  def detail
      
  end


  def eticket
    @data = Api::Account::TiketPesawatController.eTiket(session[:acc_token], params[:kode])
    render json: @data
    # render 'email/e-ticket', layout: 'application_email'
  end

  def eticket_pdf
    # https://s3-ap-southeast-1.amazonaws.com/traveloka/agent/bookings/pdf/2016/12/23/118320924Depart-447000479040af46e6b0660297aad5c9.pdf
    # localhost:3000/e-ticket/pdf/ABU242443EVC-depart-221b66b0ab2b06ca480111e0079500f4.pdf
    begin
      @data = Api::Account::TiketPesawatController.eTiket(session[:acc_token], params[:kode_booking])
      puts @data
      if params[:tipe] == 'depart'
        @index = 0
      else
        @index = 1
      end
      puts @data
      if @data['dataMain'] && @data['dataMain'][@index]
        puts Digest::MD5.hexdigest(@data['dataMain'][@index]['order_id_new'])
        order_id_hashed = Digest::MD5.hexdigest(@data['dataMain'][@index]['order_id_new'])
        if order_id_hashed = params[:hash]
          respond_to do |format|
            format.pdf do
              render :pdf => "#{params[:order_id]}-#{params[:tipe]}-#{params[:hash]}.pdf",
                     :disposition => "inline",
                     viewport_size: '1280x1024',
                     :template => "email/e-ticket_pdf.html.erb",
                     :layout => "application_email_pdf",
                     # page_size: 'A4',
                     disable_smart_shrinking: true,
                     book: false,
                     image_quality: 100,
                     lowquality: false,
                     zoom: 0.70,
                     print_media_type: false,
                     margin: {
                         top: 0,
                         left: 0,
                         right: 0,
                         bottom: 0
                     }
            end
            format.html
          end
        else
          redirect_to '/error/404'
        end
      end
    rescue Exception => e
     render json: e
    end
  end

  def pencarian
    begin
      # hasil pencarian
      tanggal_berangkat = TimeFormat::indonesiaCustom(params['tgl-b'], {:format => 'hbt', :operator => '-', :locale => 'en'})
      if params['tgl-p'] && params['checkbox']
        tanggal_pulang = TimeFormat::indonesiaCustom(params['tgl-p'], {:format => 'hbt', :operator => '-', :locale => 'en'})
      else
        tanggal_pulang = nil
      end

      # utk mengisi combobox, ganti pencarian
      @bandara = Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
      @bandara_terdekat = Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
      @bandara_terdekatApi = Api::Account::TiketPesawatController.bandaraTerdekat(session[:acc_token], session[:tiket])
      @bandara_terdekat.unshift(@bandara_terdekatApi[0])

      @daftar_keberangkatan = Api::Account::TiketPesawatController.pencarianMaskapai(
          session[:acc_token],
          session[:tiket],
          params['b'],
          params['p'],
          tanggal_berangkat,
          params['dewasa'],
          params['anak'],
          params['bayi'],
          tanggal_pulang
      )

      if @daftar_keberangkatan && @daftar_keberangkatan['departures']
        @daftar_maskapai_berangkat = @daftar_keberangkatan['departures']['result']
        if params['tgl-p'] && params['checkbox'] && @daftar_keberangkatan['returns']
          @daftar_maskapai_pulang = @daftar_keberangkatan['returns']['result']
        end
      end

      if @daftar_maskapai_berangkat
        @daftar_maskapai_berangkat = @daftar_maskapai_berangkat.sort_by { |a|  a['price_value'].to_f }
      end

      if @daftar_maskapai_pulang
        @daftar_maskapai_pulang = @daftar_maskapai_pulang.sort_by { |a|  a['price_value'].to_f }
      end

      if params['checkbox']
        # render json: @daftar_keberangkatan
        render 'accounts/evoucher/tiket-pesawat/ticketwo'
      else
        render 'accounts/evoucher/tiket-pesawat/ticketone'
      end

    rescue Exception => e
      puts "ERR: #{e} #{e.backtrace.join("\n")}"

      @daftar_keberangkatan = nil
      @daftar_maskapai_berangkat = nil
      @daftar_maskapai_pulang = nil
      if params['checkbox']
        render 'accounts/evoucher/tiket-pesawat/ticketwo'
      else
        render 'accounts/evoucher/tiket-pesawat/ticketone'
      end
    end
  end

  def pencarian_landing
    begin

      # hasil pencarian
      tanggal_berangkat = TimeFormat::indonesiaCustom(params['tgl-b'], {:format => 'hbt', :operator => '-', :locale => 'en'})
      if params['tgl-p'] && params['checkbox']
        tanggal_pulang = TimeFormat::indonesiaCustom(params['tgl-p'], {:format => 'hbt', :operator => '-', :locale => 'en'})
      else
        tanggal_pulang = nil
      end

      # utk mengisi combobox, ganti pencarian
      @bandara = Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
      @bandara_terdekat = Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
      @bandara_terdekatApi = Api::Account::TiketPesawatController.bandaraTerdekat(session[:acc_token], session[:tiket])
      @bandara_terdekat.unshift(@bandara_terdekatApi[0])

      @daftar_keberangkatan = Api::Account::TiketPesawatController.pencarianMaskapai(
          session[:acc_token],
          session[:tiket],
          params['b'],
          params['p'],
          tanggal_berangkat,
          params['dewasa'],
          params['anak'],
          params['bayi'],
          tanggal_pulang
      )

      if @daftar_keberangkatan && @daftar_keberangkatan['departures']
        @daftar_maskapai_berangkat = @daftar_keberangkatan['departures']['result']
        if params['tgl-p'] && params['checkbox'] && @daftar_keberangkatan['returns']
          @daftar_maskapai_pulang = @daftar_keberangkatan['returns']['result']
        end
      end

      if @daftar_maskapai_berangkat
        @daftar_maskapai_berangkat = @daftar_maskapai_berangkat.sort_by { |a|  a['price_value'].to_f }
      end

      if @daftar_maskapai_pulang
        @daftar_maskapai_pulang = @daftar_maskapai_pulang.sort_by { |a|  a['price_value'].to_f }
      end

      if params['checkbox']
        render 'evoucher/searchticket_s2'
      else
        render 'evoucher/searchticket_s1'
      end

    rescue Exception => e
      puts "ERR: #{e} #{e.backtrace.join("\n")}"
      @daftar_keberangkatan = nil
      @daftar_maskapai_berangkat = nil
      @daftar_maskapai_pulang = nil
      # render json: @daftar_keberangkatan and return
      if params['checkbox']
        render 'evoucher/searchticket_s2'
      else
        render 'evoucher/searchticket_s1'
      end

    end
  end

  def ticketone
    render 'accounts/evoucher/tiket-pesawat/ticketone'
  end

  def book
    @res = params['res']
    # render 'payment/formpemesanantiket'
    @info_flight = Api::Account::TiketPesawatController.infoPenumpang(session[:acc_token], session[:tiket], params['fi'], params['rfi'])
    @countryTiket = Api::Account::TiketPesawatController.listCountry(session[:acc_token], 'f00d9fcdadde7d6ffe2e196e043ab21b5e8b2d72')['listCountry']
    # render json: @countryTiket
    render 'accounts/evoucher/tiket-pesawat/book-ari', layout: 'application_payments'
  end

  def tiketExample
    data = '[
    {
        "err_code": "00",
        "message": "Sukses",
        "status": "3",
        "airline": "GAR",
        "adult_request": "1",
        "child_request": "0",
        "infant_request": "0",
        "data": {
            "item": [
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 654",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 01:20",
                            "depart_time": "01:20",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 04:55",
                            "arrive_time": "04:55",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:35",
                            "id": "812011487bfab074c06222aac1fb1ae2"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "2f5cf5f7195ca244e15c605a468d3ab4",
                            "by_ages": {
                                "adult": {
                                    "basic": "790000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "214000",
                                    "iwjr": "0",
                                    "total": "1004000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "a213fd2e4e373f174f39f856860b3fb7",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "44ee7bb8a43300e1b3fbc34d2e3ab983",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "9b104e7d2dca3508efdfcc941f145a69"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 604",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 05:10",
                            "depart_time": "05:10",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 08:40",
                            "arrive_time": "08:40",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "25c066342e7120f4e9dc76ee4e8a0a36"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "c62051ae5ef70c6d8c3cede0de01bc01",
                            "by_ages": {
                                "adult": {
                                    "basic": "915000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "226500",
                                    "iwjr": "0",
                                    "total": "1141500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "5ad7051a4f336dc62a665d47af4c9280",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "4d743e38ba9f5fd3b795b14de5e58c9f",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "0e5edc39b62e07c47f780d8629dff2a5"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 642",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 07:15",
                            "depart_time": "07:15",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 10:45",
                            "arrive_time": "10:45",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "aad991fb1bdb6205417672b897fc9fee"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "7b58ac79e0f177510c551deea18ed01b",
                            "by_ages": {
                                "adult": {
                                    "basic": "1030000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "238000",
                                    "iwjr": "0",
                                    "total": "1268000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "d15c84440ffc3ea0a41dd9073a2e6510",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "50f8dd33131add1ea1dbaf0b3a2e0ae8",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "aa5f1890eb3491d18ca38df6ab49a429"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 608",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 09:40",
                            "depart_time": "09:40",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 13:10",
                            "arrive_time": "13:10",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "ecba90ce413f5b7186ac33bcafb5f106"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "265d5038e4b9f70ab7cbcfd647a80e59",
                            "by_ages": {
                                "adult": {
                                    "basic": "915000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "226500",
                                    "iwjr": "0",
                                    "total": "1141500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "7001d8eb09d7d5bd653be53c60e272fe",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "46f1f9250fedc639f2f1b3f308caa91e",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "ea78f9e08e5355007bbfbb36d6d48be6"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 618",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 11:00",
                            "depart_time": "11:00",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 14:30",
                            "arrive_time": "14:30",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "fcee6b090b8ac21935c608f54f666a4c"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "96c9621e676ce86f18e9389063e7f2f9",
                            "by_ages": {
                                "adult": {
                                    "basic": "915000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "226500",
                                    "iwjr": "0",
                                    "total": "1141500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "0e0b0ffdb5fe943e250e805ab2dfc90a",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "f138afd6585b7380411799183b322fec",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "d35511473bb5a3720ab251e6cdf0ab2c"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 616",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 13:00",
                            "depart_time": "13:00",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 16:30",
                            "arrive_time": "16:30",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "2408c7b4c5ebd4cc57c3420a1a4b3008"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "4a7942b0a2a465d6ec2ca5f5ab7a7c6f",
                            "by_ages": {
                                "adult": {
                                    "basic": "915000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "226500",
                                    "iwjr": "0",
                                    "total": "1141500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "0b80d80e008a665b46cff80b93bef496",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "2c6bfcbf7a808b2b14289ef87206697f",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "d4c13c7fe2914ef11660342213ce4ade"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 610",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 15:00",
                            "depart_time": "15:00",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 18:30",
                            "arrive_time": "18:30",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "7b64867736e8a65a2c502cdfb59dac96"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "bb72a6d09fb7cd8a89ebbbadbcf4571c",
                            "by_ages": {
                                "adult": {
                                    "basic": "915000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "226500",
                                    "iwjr": "0",
                                    "total": "1141500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "7f0a72ebc0503f5e8850cc2ed89ffc9c",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "c231ae287115d4839de4ca5bd5bfc897",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "290c13da753a2924d60aa71cc80cdaf0"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 612",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 17:45",
                            "depart_time": "17:45",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 21:05",
                            "arrive_time": "21:05",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:20",
                            "id": "d420a952d9eea09095d2592ddd82df11"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "870b18f717fc4d4170ac53dd2471a9c7",
                            "by_ages": {
                                "adult": {
                                    "basic": "915000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "226500",
                                    "iwjr": "0",
                                    "total": "1141500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "9bda79eef89c17a7f5c0794de65cbab9",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "04fc33aa2f544ce755f7eccb8bad4691",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "3e7ce1fe62b60e679523b138699f7f47"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 614",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 19:15",
                            "depart_time": "19:15",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-28 22:45",
                            "arrive_time": "22:45",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "0e5dbaaf38ded84cf879a5e4bcada73f"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "8488de297e0831ada7d26d7c2d795e92",
                            "by_ages": {
                                "adult": {
                                    "basic": "790000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "214000",
                                    "iwjr": "0",
                                    "total": "1004000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "915723610c89e960e3d70e107b76c741",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "afd160d30054df4e89aef4882839a9c8",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "29917d222d08383eaf1ed92f66ddbde8"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 650",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 21:00",
                            "depart_time": "21:00",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-29 00:30",
                            "arrive_time": "00:30",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "2de7c95f2cabdaad436e76654dfb05e6"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "ea875cebf84dbc9145ef83d912b64ef4",
                            "by_ages": {
                                "adult": {
                                    "basic": "915000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "226500",
                                    "iwjr": "0",
                                    "total": "1141500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "478baa4150daeb51d899e72d79556fc2",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "d9fbdca63631bc9a60096824c675cfa1",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "f285db5af9103e167ee20dc12afe9137"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 658",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 21:55",
                            "depart_time": "21:55",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-29 01:30",
                            "arrive_time": "01:30",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:35",
                            "id": "2fe511db0d6f19462e8f084c9fd22a2a"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "ab08e779b211d14d967a4b5265864548",
                            "by_ages": {
                                "adult": {
                                    "basic": "1030000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "238000",
                                    "iwjr": "0",
                                    "total": "1268000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "8acb376676800fd1a4b7e9ddde4b4fd0",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "7eb47a5a957720ac078b3a2c43ba80b6",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "04e81cc651f9480bfb06c57e3a1c36af"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "GA 640",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta, Cengkareng",
                            "depart_datetime": "2017-10-28 23:45",
                            "depart_time": "23:45",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_port": "UPG",
                            "arrive_city": "Makassar",
                            "arrive_datetime": "2017-10-29 03:15",
                            "arrive_time": "03:15",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:30",
                            "id": "12a834982f3acc71a97e4254afc3c578"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "3acfadd98211018f75b8377c702e9a45",
                            "by_ages": {
                                "adult": {
                                    "basic": "790000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "214000",
                                    "iwjr": "0",
                                    "total": "1004000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "109630132f30de3520a23df1d376a85a",
                            "by_ages": {
                                "adult": {
                                    "basic": "1580000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "293000",
                                    "iwjr": "0",
                                    "total": "1873000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "c6beae1b886b78e746574a4c5b475c05",
                            "by_ages": {
                                "adult": {
                                    "basic": "2925000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "427500",
                                    "iwjr": "0",
                                    "total": "3352500"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "4c895df9c4a8ccfd40777acdce241d1f"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 448",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 15:45",
                                "depart_time": "15:45",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "SUB",
                                "arrive_city": "Surabaya",
                                "arrive_datetime": "2017-10-28 17:25",
                                "arrive_time": "17:25",
                                "arrive_timezone": "Asia/Jakarta",
                                "flight_duration": "01:40",
                                "id": "c1b923974a2ce33aeaa7d019eb99a4ef"
                            },
                            {
                                "flight_num": "GA 367",
                                "depart_port": "SUB",
                                "depart_city": "Surabaya",
                                "depart_datetime": "2017-10-28 18:10",
                                "depart_time": "18:10",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 20:45",
                                "arrive_time": "20:45",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:35",
                                "id": "be361c35b57a9c32b929a1764faa9b8e"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": null,
                        "eco": {
                            "id": "03ddc823e15ce000a0486c2b6f3a5f97",
                            "by_ages": {
                                "adult": {
                                    "basic": "2391000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "379100",
                                    "iwjr": "0",
                                    "total": "2770100"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "ce41a7aee4b7eaa2621990ff3eb47f4f"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 568",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 13:40",
                                "depart_time": "13:40",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "BPN",
                                "arrive_city": "Balikpapan",
                                "arrive_datetime": "2017-10-28 16:55",
                                "arrive_time": "16:55",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "02:15",
                                "id": "c17ee92a9ebaee110af29c60fff2d502"
                            },
                            {
                                "flight_num": "GA 632",
                                "depart_port": "BPN",
                                "depart_city": "Balikpapan",
                                "depart_datetime": "2017-10-28 17:50",
                                "depart_time": "17:50",
                                "depart_timezone": "Asia/Makassar",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 19:00",
                                "arrive_time": "19:00",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:10",
                                "id": "af1ce6638d8a6243abb98e91e45f9031"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": {
                            "id": "84afc32654914b3020c877e11763c543",
                            "by_ages": {
                                "adult": {
                                    "basic": "1400000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "280000",
                                    "iwjr": "0",
                                    "total": "1680000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "df5f55b0a77c724ca4991e6167891586",
                            "by_ages": {
                                "adult": {
                                    "basic": "2380000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "378000",
                                    "iwjr": "0",
                                    "total": "2758000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "69e3616ad750a3d4b7f1f7daa5c24aaa"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 316",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 13:30",
                                "depart_time": "13:30",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "SUB",
                                "arrive_city": "Surabaya",
                                "arrive_datetime": "2017-10-28 15:05",
                                "arrive_time": "15:05",
                                "arrive_timezone": "Asia/Jakarta",
                                "flight_duration": "01:35",
                                "id": "fd1f373e2b43bd9de245b420acf5eed6"
                            },
                            {
                                "flight_num": "GA 671",
                                "depart_port": "SUB",
                                "depart_city": "Surabaya",
                                "depart_datetime": "2017-10-28 16:25",
                                "depart_time": "16:25",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 18:55",
                                "arrive_time": "18:55",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:30",
                                "id": "80a8307fff9c62a3dc3b37b77e6f96ce"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": {
                            "id": "baf860c3a395b4d61cc1b826ccfd8604",
                            "by_ages": {
                                "adult": {
                                    "basic": "1270000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "267000",
                                    "iwjr": "0",
                                    "total": "1537000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "08cf6086256ad59796806c9e0f2c615b",
                            "by_ages": {
                                "adult": {
                                    "basic": "2200000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "360000",
                                    "iwjr": "0",
                                    "total": "2560000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "c6df25bce24ed71b18558daec304ee64"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 202",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 05:30",
                                "depart_time": "05:30",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "JOG",
                                "arrive_city": "Yogyakarta",
                                "arrive_datetime": "2017-10-28 06:40",
                                "arrive_time": "06:40",
                                "arrive_timezone": "Asia/Jakarta",
                                "flight_duration": "01:10",
                                "id": "0ab4a529c1cb52081b3773164ad89322"
                            },
                            {
                                "flight_num": "GA 695",
                                "depart_port": "JOG",
                                "depart_city": "Yogyakarta",
                                "depart_datetime": "2017-10-28 08:10",
                                "depart_time": "08:10",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 11:05",
                                "arrive_time": "11:05",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:55",
                                "id": "7df3e9c40a08b3637b4555729c273741"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": null,
                        "eco": {
                            "id": "5c1216297c8738d4cde4bbaef2bc865c",
                            "by_ages": {
                                "adult": {
                                    "basic": "2255000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "365500",
                                    "iwjr": "0",
                                    "total": "2620500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "dd26ab0dfd69e84b6f1031d27dafebb1"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 318",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 15:10",
                                "depart_time": "15:10",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "SUB",
                                "arrive_city": "Surabaya",
                                "arrive_datetime": "2017-10-28 16:45",
                                "arrive_time": "16:45",
                                "arrive_timezone": "Asia/Jakarta",
                                "flight_duration": "01:35",
                                "id": "542529d32d357d34754f03e663f0bdeb"
                            },
                            {
                                "flight_num": "GA 367",
                                "depart_port": "SUB",
                                "depart_city": "Surabaya",
                                "depart_datetime": "2017-10-28 18:10",
                                "depart_time": "18:10",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 20:45",
                                "arrive_time": "20:45",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:35",
                                "id": "9f1dd0b0cac1bda650046b4a476c7e69"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": {
                            "id": "eb67199a724ccd236eb9d525b690b29a",
                            "by_ages": {
                                "adult": {
                                    "basic": "1350000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "275000",
                                    "iwjr": "0",
                                    "total": "1625000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "38e352a6333b614d1b8c7d8ccbbb4fd9",
                            "by_ages": {
                                "adult": {
                                    "basic": "2200000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "360000",
                                    "iwjr": "0",
                                    "total": "2560000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "61f2e0bfcc738261ce65ee3dd8808de9"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 422",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 13:10",
                                "depart_time": "13:10",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "DPS",
                                "arrive_city": "Denpasar, Bali",
                                "arrive_datetime": "2017-10-28 16:10",
                                "arrive_time": "16:10",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "02:00",
                                "id": "ae2dcbbd56e181cff3b9b88f3765b2ac"
                            },
                            {
                                "flight_num": "GA 620",
                                "depart_port": "DPS",
                                "depart_city": "Denpasar, Bali",
                                "depart_datetime": "2017-10-28 17:30",
                                "depart_time": "17:30",
                                "depart_timezone": "Asia/Makassar",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 18:50",
                                "arrive_time": "18:50",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:20",
                                "id": "257eae932b402fa0215bd1c0bd520570"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": null,
                        "eco": {
                            "id": "1fa8bf4df727c105dcd5c1fa69343722",
                            "by_ages": {
                                "adult": {
                                    "basic": "2535000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "393500",
                                    "iwjr": "0",
                                    "total": "2928500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "a162c9e98aea05d33373bab386686701",
                            "by_ages": {
                                "adult": {
                                    "basic": "4796000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "619600",
                                    "iwjr": "0",
                                    "total": "5415600"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "08371db3674062865d17d8d02ff92f66"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 314",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 12:50",
                                "depart_time": "12:50",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "SUB",
                                "arrive_city": "Surabaya",
                                "arrive_datetime": "2017-10-28 14:30",
                                "arrive_time": "14:30",
                                "arrive_timezone": "Asia/Jakarta",
                                "flight_duration": "01:40",
                                "id": "55b499a8832e28fe8f0c947c9cc2b74c"
                            },
                            {
                                "flight_num": "GA 671",
                                "depart_port": "SUB",
                                "depart_city": "Surabaya",
                                "depart_datetime": "2017-10-28 16:25",
                                "depart_time": "16:25",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 18:55",
                                "arrive_time": "18:55",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:30",
                                "id": "cd3d41c150477adc0cbdd135731762b0"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": {
                            "id": "0cb3fceb67ce21bc6630b6e7f1d39b0b",
                            "by_ages": {
                                "adult": {
                                    "basic": "1270000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "267000",
                                    "iwjr": "0",
                                    "total": "1537000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "2ea0f83152eaeb11e58ada35ccf7eed4",
                            "by_ages": {
                                "adult": {
                                    "basic": "2200000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "360000",
                                    "iwjr": "0",
                                    "total": "2560000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "38d1b6897a896e7fe0fa9f5ee211d7fc"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 240",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 14:25",
                                "depart_time": "14:25",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "SRG",
                                "arrive_city": "Semarang",
                                "arrive_datetime": "2017-10-28 15:35",
                                "arrive_time": "15:35",
                                "arrive_timezone": "Asia/Jakarta",
                                "flight_duration": "01:10",
                                "id": "44f092a68d101399ff0f65d04440bbaa"
                            },
                            {
                                "flight_num": "GA 367",
                                "depart_port": "SRG",
                                "depart_city": "Semarang",
                                "depart_datetime": "2017-10-28 16:30",
                                "depart_time": "16:30",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 20:45",
                                "arrive_time": "20:45",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "03:15",
                                "id": "d845b537a11a8a641e75e8d5c747e239"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": null,
                        "eco": {
                            "id": "a86443545e8da25302faf09d6308563f",
                            "by_ages": {
                                "adult": {
                                    "basic": "2300000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "370000",
                                    "iwjr": "0",
                                    "total": "2670000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "8e32c3b3c69b7c53fa873b716b9f115d"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 408",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 11:35",
                                "depart_time": "11:35",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "DPS",
                                "arrive_city": "Denpasar, Bali",
                                "arrive_datetime": "2017-10-28 14:30",
                                "arrive_time": "14:30",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:55",
                                "id": "fcb619c151cfa8dcc9997a0b6b8713c2"
                            },
                            {
                                "flight_num": "GA 620",
                                "depart_port": "DPS",
                                "depart_city": "Denpasar, Bali",
                                "depart_datetime": "2017-10-28 17:30",
                                "depart_time": "17:30",
                                "depart_timezone": "Asia/Makassar",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 18:50",
                                "arrive_time": "18:50",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:20",
                                "id": "f92b451280b148b7d594219f870a0023"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": null,
                        "eco": {
                            "id": "daee999878cf8110ef2f7b3a855f9451",
                            "by_ages": {
                                "adult": {
                                    "basic": "2745000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "414500",
                                    "iwjr": "0",
                                    "total": "3159500"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "91f25d7049303a750b2c7762cd2a5c92",
                            "by_ages": {
                                "adult": {
                                    "basic": "4074000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "547400",
                                    "iwjr": "0",
                                    "total": "4621400"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "c2248fcbcd5fc622707d0618084c1147"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "GA 316",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta, Cengkareng",
                                "depart_datetime": "2017-10-28 13:30",
                                "depart_time": "13:30",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "SUB",
                                "arrive_city": "Surabaya",
                                "arrive_datetime": "2017-10-28 15:05",
                                "arrive_time": "15:05",
                                "arrive_timezone": "Asia/Jakarta",
                                "flight_duration": "01:35",
                                "id": "8bd0db4c057996b693f2d079adaa1644"
                            },
                            {
                                "flight_num": "GA 367",
                                "depart_port": "SUB",
                                "depart_city": "Surabaya",
                                "depart_datetime": "2017-10-28 18:10",
                                "depart_time": "18:10",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_port": "UPG",
                                "arrive_city": "Makassar",
                                "arrive_datetime": "2017-10-28 20:45",
                                "arrive_time": "20:45",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:35",
                                "id": "8f6f89fc8c617f2ce2a8de546a09960b"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": {
                            "id": "be3ec2422908ad1a00a96c36f9019f59",
                            "by_ages": {
                                "adult": {
                                    "basic": "1350000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "275000",
                                    "iwjr": "0",
                                    "total": "1625000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "cf128f582b15e7d67f787ead6abed088",
                            "by_ages": {
                                "adult": {
                                    "basic": "2200000",
                                    "tax": "0",
                                    "fuel": "0",
                                    "adm": "360000",
                                    "iwjr": "0",
                                    "total": "2560000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "453b49d7c449aa06944518abd46fe406"
                }
            ],
            "@xsi:type": "SOAP-ENC:Array",
            "@soap_enc:array_type": "unnamed_struct_use_soapval[22]"
        }
    },
    {
        "err_code": "00",
        "message": "Sukses",
        "status": "3",
        "airline": "LIO",
        "adult_request": "1",
        "child_request": "0",
        "infant_request": "0",
        "data": {
            "item": [
                {
                    "flights": {
                        "item": {
                            "flight_num": "ID 6196",
                            "depart_time": "00:05",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "03:20",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 00:05",
                            "arrive_datetime": "2017-10-28 03:20",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:15",
                            "id": "3b8112cd7ab766dc1d8ab37628996c73"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "d21d34b2623b9606eedab63a2c2655ef",
                            "by_ages": {
                                "adult": {
                                    "basic": "580000",
                                    "tax": "58000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "693000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "d61dbc168c20fe9aa5946dc71564841c",
                            "by_ages": {
                                "adult": {
                                    "basic": "800000",
                                    "tax": "80000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "935000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "41a34b8d763db209fb437ba29ee0a27e",
                            "by_ages": {
                                "adult": {
                                    "basic": "1660000",
                                    "tax": "166000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1881000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "74f6b7521b04b5d24438eb4013802dd4"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "JT 898",
                            "depart_time": "04:00",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "07:25",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 04:00",
                            "arrive_datetime": "2017-10-28 07:25",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "64588c6b1edbfbdc0c76c93f66f87ebf"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "4b37d15bef58370f4ab10dda4f780449",
                            "by_ages": {
                                "adult": {
                                    "basic": "547000",
                                    "tax": "54700",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "656700"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "4414b827fd70548e494d08d3f5865adc",
                            "by_ages": {
                                "adult": {
                                    "basic": "750000",
                                    "tax": "75000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "880000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "eca7e8172aec2949b776b60a18306a66"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "JT 792",
                            "depart_time": "05:00",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "08:25",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 05:00",
                            "arrive_datetime": "2017-10-28 08:25",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "54b9889fd78a331cd510c4f278843ce1"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "d466aa859e35f9e71fa8eee033d3bdc4",
                            "by_ages": {
                                "adult": {
                                    "basic": "547000",
                                    "tax": "54700",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "656700"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "0ed8d948c6f620be03194ba17c6d71fd",
                            "by_ages": {
                                "adult": {
                                    "basic": "750000",
                                    "tax": "75000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "880000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "659b922c43dc1e39bf5575704af1254a"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "ID 6288",
                            "depart_time": "05:35",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "09:00",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 05:35",
                            "arrive_datetime": "2017-10-28 09:00",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "6d9d249a2261d1ad797f44fa1cb3461f"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "51f571292c36bf74f86a5c4b257b8029",
                            "by_ages": {
                                "adult": {
                                    "basic": "640000",
                                    "tax": "64000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "759000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "801226187455a1763ab4fc2409cb2891",
                            "by_ages": {
                                "adult": {
                                    "basic": "800000",
                                    "tax": "80000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "935000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "e2611cade5bfa5148be06ca962a2859b",
                            "by_ages": {
                                "adult": {
                                    "basic": "1660000",
                                    "tax": "166000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1881000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "9b82d3bb7ec4174977d04a9f5c5fffcb"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "ID 6182",
                            "depart_time": "07:35",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "11:00",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 07:35",
                            "arrive_datetime": "2017-10-28 11:00",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "b84648f20d457f95c18dc52e1147a1c0"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "d5ab7df819e05dec2616f80d9c60f6e7",
                            "by_ages": {
                                "adult": {
                                    "basic": "640000",
                                    "tax": "64000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "759000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "fed08bdd588d1a6d9a1f44f02fb16d08",
                            "by_ages": {
                                "adult": {
                                    "basic": "800000",
                                    "tax": "80000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "935000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "def58c0e7ca7cef6a2a067f1dd06aab0",
                            "by_ages": {
                                "adult": {
                                    "basic": "1660000",
                                    "tax": "166000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1881000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "7b45482aecf4a137be8073f90c06a28d"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "JT 778",
                            "depart_time": "08:15",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "11:40",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 08:15",
                            "arrive_datetime": "2017-10-28 11:40",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "0f4f72aacf53e77d5acc1525ff49eb5b"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "5e7585031dd543a56376fca7c5b097b2",
                            "by_ages": {
                                "adult": {
                                    "basic": "547000",
                                    "tax": "54700",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "656700"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "8104ace18a67413bd29aa52b9edc8385",
                            "by_ages": {
                                "adult": {
                                    "basic": "750000",
                                    "tax": "75000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "880000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "fa7a49b494789ddf7924c95c98fb1989"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "ID 6262",
                            "depart_time": "08:40",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "12:05",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 08:40",
                            "arrive_datetime": "2017-10-28 12:05",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "e5b6a844d7363d277f5ebc3bd52986c3"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "42c07d8af6d9409e350bc91618aebe31",
                            "by_ages": {
                                "adult": {
                                    "basic": "720000",
                                    "tax": "72000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "847000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "b3f0ca378978fcd1721627a2802c833c",
                            "by_ages": {
                                "adult": {
                                    "basic": "800000",
                                    "tax": "80000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "935000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "6571d2095dc3bba34cf563169ac8c8c1",
                            "by_ages": {
                                "adult": {
                                    "basic": "1660000",
                                    "tax": "166000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1881000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "5fee420aa58fd506720d96ba6879d581"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "ID 6296",
                            "depart_time": "10:45",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "14:10",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 10:45",
                            "arrive_datetime": "2017-10-28 14:10",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "d972d2d61df9e07034c05c020e6e78b3"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "342413bf38a1fb1e73048ae95ee5c03e",
                            "by_ages": {
                                "adult": {
                                    "basic": "640000",
                                    "tax": "64000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "759000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "f7790165fe691570ca18c52719be389c",
                            "by_ages": {
                                "adult": {
                                    "basic": "800000",
                                    "tax": "80000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "935000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "084079a3ada8fcf1390a80e829131a69",
                            "by_ages": {
                                "adult": {
                                    "basic": "1660000",
                                    "tax": "166000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1881000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "940e4d811037afddabd9e6068b66b9fc"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "JT 774",
                            "depart_time": "11:20",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "14:40",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 11:20",
                            "arrive_datetime": "2017-10-28 14:40",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:20",
                            "id": "7266cefca03e3b33a04544a31eabc2c9"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "bfac08ea6c62758647c2180f38f32888",
                            "by_ages": {
                                "adult": {
                                    "basic": "610000",
                                    "tax": "61000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "726000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "396886296649698a08eec85e31e57f50",
                            "by_ages": {
                                "adult": {
                                    "basic": "750000",
                                    "tax": "75000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "880000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "f3a385588173b87d5e756a04650a50fe"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "JT 892",
                            "depart_time": "13:10",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "16:30",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 13:10",
                            "arrive_datetime": "2017-10-28 16:30",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:20",
                            "id": "bc3e93160754f6482786df854928226b"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "5cfb8283c1d551d1bb98e00bf97a7181",
                            "by_ages": {
                                "adult": {
                                    "basic": "547000",
                                    "tax": "54700",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "656700"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "e0e8aa8debd027d77766cad67aa66bcf",
                            "by_ages": {
                                "adult": {
                                    "basic": "750000",
                                    "tax": "75000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "880000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "29bc8e0a84fef22ac0bf7148569ba23a"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "ID 6268",
                            "depart_time": "14:40",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "18:00",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 14:40",
                            "arrive_datetime": "2017-10-28 18:00",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:20",
                            "id": "ebb53aecaf4faab47db73a1d53d99164"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "c34e97ed5c893e944ca74c092f9f6c7d",
                            "by_ages": {
                                "adult": {
                                    "basic": "720000",
                                    "tax": "72000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "847000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "56d2b4818d90189945c0c6fedd339008",
                            "by_ages": {
                                "adult": {
                                    "basic": "800000",
                                    "tax": "80000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "935000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "f1ffba89dfe3a5c5fed52b55d4fac149",
                            "by_ages": {
                                "adult": {
                                    "basic": "1660000",
                                    "tax": "166000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1881000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "482d1cb8cbb67b604a589983d9e9ee44"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "JT 782",
                            "depart_time": "16:45",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "20:10",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 16:45",
                            "arrive_datetime": "2017-10-28 20:10",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "cbc2db47be2a22ae332eb2b437860d65"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "7fb8906eb275f16e1f86fe421c4fa179",
                            "by_ages": {
                                "adult": {
                                    "basic": "547000",
                                    "tax": "54700",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "656700"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "d49f29c944f77769d0b4b2d8d74a98a1",
                            "by_ages": {
                                "adult": {
                                    "basic": "750000",
                                    "tax": "75000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "880000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "c53c67b996040c709fb95bfc2be5f80c"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "ID 6264",
                            "depart_time": "18:45",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "22:05",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 18:45",
                            "arrive_datetime": "2017-10-28 22:05",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:20",
                            "id": "fd14c4545a6f64b3730ca7eb864b3cd4"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": null,
                        "eco": {
                            "id": "4884ec4afa3a0b91560e718c19d06033",
                            "by_ages": {
                                "adult": {
                                    "basic": "950000",
                                    "tax": "95000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1100000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "7960d6e0b2214be3fcf8dc88798a1e8f",
                            "by_ages": {
                                "adult": {
                                    "basic": "1660000",
                                    "tax": "166000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1881000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "18c3a2b17c390a22a7d3f66dec6c3598"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "JT 798",
                            "depart_time": "21:40",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "01:00",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 21:40",
                            "arrive_datetime": "2017-10-29 01:00",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:20",
                            "id": "8e7a2b9ffdf7ee2ff9eeb8f885269662"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "d956f8033face0926b9a48d0d8147e67",
                            "by_ages": {
                                "adult": {
                                    "basic": "547000",
                                    "tax": "54700",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "656700"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "47340a98467ea7b5f13cd78ebc2f14f8",
                            "by_ages": {
                                "adult": {
                                    "basic": "750000",
                                    "tax": "75000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "880000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": null
                    },
                    "id": "2a5c7939291a1654f7b83fe7d3fa9025"
                },
                {
                    "flights": {
                        "item": {
                            "flight_num": "ID 6166",
                            "depart_time": "22:15",
                            "depart_port": "CGK",
                            "depart_city": "Jakarta",
                            "arrive_time": "01:40",
                            "arrive_port": "UPG",
                            "arrive_city": "Ujung Pandang",
                            "depart_datetime": "2017-10-28 22:15",
                            "arrive_datetime": "2017-10-29 01:40",
                            "depart_timezone": "Asia/Jakarta",
                            "arrive_timezone": "Asia/Makassar",
                            "flight_duration": "02:25",
                            "id": "22e03f60478e578c6cc76828df7a9c2a"
                        },
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[1]"
                    },
                    "fares": {
                        "pro": {
                            "id": "cd500ddf130b28cc702a364c9cc2bc5e",
                            "by_ages": {
                                "adult": {
                                    "basic": "580000",
                                    "tax": "58000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "693000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "91563fa7c8d6f08362100cad19737b47",
                            "by_ages": {
                                "adult": {
                                    "basic": "800000",
                                    "tax": "80000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "935000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "ed1caae57f4946538dfcd9ac5a4d5f2a",
                            "by_ages": {
                                "adult": {
                                    "basic": "1660000",
                                    "tax": "166000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "5000",
                                    "total": "1881000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "6d5f8fc9cf2908a70559288a2f513805"
                },
                {
                    "flights": {
                        "item": [
                            {
                                "flight_num": "ID 6170",
                                "depart_time": "00:30",
                                "depart_port": "CGK",
                                "depart_city": "Jakarta",
                                "arrive_time": "06:00",
                                "arrive_port": "AMQ",
                                "arrive_city": "Ambon",
                                "depart_datetime": "2017-10-28 00:30",
                                "arrive_datetime": "2017-10-28 06:00",
                                "depart_timezone": "Asia/Jakarta",
                                "arrive_timezone": "Asia/Jayapura",
                                "flight_duration": "03:30",
                                "id": "3dc6f278829bf76c1b95c2a49d0ee27f"
                            },
                            {
                                "flight_num": "ID 6167",
                                "depart_time": "06:45",
                                "depart_port": "AMQ",
                                "depart_city": "Ambon",
                                "arrive_time": "07:35",
                                "arrive_port": "UPG",
                                "arrive_city": "Ujung Pandang",
                                "depart_datetime": "2017-10-28 06:45",
                                "arrive_datetime": "2017-10-28 07:35",
                                "depart_timezone": "Asia/Jayapura",
                                "arrive_timezone": "Asia/Makassar",
                                "flight_duration": "01:50",
                                "id": "26b6ebc149dba24cfdb24bbe3f8fbc0e"
                            }
                        ],
                        "@xsi:type": "SOAP-ENC:Array",
                        "@soap_enc:array_type": "unnamed_struct_use_soapval[2]"
                    },
                    "fares": {
                        "pro": {
                            "id": "ac5da9ede20bffa7dc9eebe477a1403c",
                            "by_ages": {
                                "adult": {
                                    "basic": "1730000",
                                    "tax": "173000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "10000",
                                    "total": "1963000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "eco": {
                            "id": "a9a8c1635a5da81ab0b888bed7cc0471",
                            "by_ages": {
                                "adult": {
                                    "basic": "1980000",
                                    "tax": "198000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "10000",
                                    "total": "2238000"
                                },
                                "child": null,
                                "infant": null
                            }
                        },
                        "bus": {
                            "id": "a6367d3b811cec1ca0c847bceaa46585",
                            "by_ages": {
                                "adult": {
                                    "basic": "4150000",
                                    "tax": "415000",
                                    "fuel": "0",
                                    "adm": "50000",
                                    "iwjr": "10000",
                                    "total": "4625000"
                                },
                                "child": null,
                                "infant": null
                            }
                        }
                    },
                    "id": "bbba0d4a053a7398e08ee4d87141c983"
                }
            ],
            "@xsi:type": "SOAP-ENC:Array",
            "@soap_enc:array_type": "unnamed_struct_use_soapval[16]"
        }
    }
]'
  end
end
