function PemesananInformasiPaket() {
    request = $.ajax({
        url: "/api/profil-update-pembelian",
        type: "post",
        data: {
            nama: $('#valid01').val(),
            email: $('#valid02').val(),
            ktp: $('#valid03').val(),
            telepon: $('#valid04').val(),
            tempat_lahir: $('#valid07').val(),
            tanggal_lahir: $('#valid05').val(),
            alamat_lengkap: $('#valid06').val(),
        },
        success: function (data) {
            console.log(data);
        }
    });
}


function jamaahInfo(){
    if ($('#jamaahInfo').val() == "") {
        return false;
    } else {
        $('#loading').show();
        $('#successAjx').hide();
        $('#failsAjx').hide();
        request = $.ajax({
        url: "/api/jamaah-info",
        type: "post",
        data: {
            nomor: $('#jamaahInfo').val()
        },
            success:function(data) {
                
                if (data['status'] == 400) {
                    console.log(data);
                    $('#loading').hide();
                    $('#successAjx').hide();
                    $('#failsAjx').show();
                } else {
                    alamat = data['data']['alamat'] +', '+ data['data']['kecamatan']+', '+data['data']['provinsi'];
                    $('#nama').html(data['data']['nama_jamaah']);
                    $('#jm-foto').attr('src', data['data']['foto']);
                    $('#tipe_produk').html(data['data']['nama_produk']);
                    $('#alamat').html(alamat);
                    $('#tgl_keberangkatan').html(data['data']['tanggal_keberangkatan']);
                    $('#loading').hide();
                    $('#failsAjx').hide();
                    $('#successAjx').show();
                    return true;
                    console.log(data);
                }
                
                
            }
        });
    }
}

// Filter history pembelian
function filterPembelian(me) {
    window.location = "/transaksi-umrah?filter="+me.value;
}
function filterPembelianEvoucher(me) {
    window.location = "/transaksi-evoucher?filter="+me.value;
}
function filterPembelianTiket(me) {
    window.location = "/transaksi-tiket?filter="+me.value;
}
function konfirmasiPembayaran(me){
    window.location = "/konfirmasi-pembayaran/"+me;
}

function invoiceUmrah(no){
    window.location = "/app/umrah/invoice/" + no;
}

// Fee
function all() {
    request = $.ajax({
        url: "/api/fee/otp",
        type: "get",
        data: {
            
        },
        success:function(data) {
            console.log(data);
        }
    });
}

// Check Voucher
function chechVoucher(vouchers){
    request = $.ajax({
        url: "/api/voucher/cekvoucher",
        type: "post",
        data: {
            kode_voucher: vouchers.value
        },
        success:function(data) {
            // console.log(data['data']['no_voucher']);
            var arr = [$('#dumpkv').html().split(",")][0];

            request = $.ajax({
                url: "/api/voucher/cekvoucher/single",
                type: "post",
                data: {
                    params_array : arr,
                    params_value : data['data']['no_voucher']
                },
                success:function(data_res) {
                    $('#voucher-response').html(data_res['message']);
                    if (data_res['response'] == false) {
                        // response false = 'jika tidak sama'
                        var values = parseInt($('#ptvc').html().replace(/(\,)/g, '')) + parseInt(data['data']['nominal']);
                        console.log(values);
                        $('#ptvc').html(values.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"));
                        $('#dumpkv').append(data['data']['no_voucher'] + ",");
                    }else if (data_res['response'] == true) {
                        vouchers.value = ""
                    }
                    
                }
            });
            // console.log(arr[0].indexOf(data['data']['no_voucher']));
        }
    });    
}

$(document).ready(function(){
    $('#voucher-uv').click(function(){
        request = $.ajax({
        url: "/api/voucher/session",
        type: "post",
        data: {
            vc: $('#dumpkv').html()
        },
            success:function(data) {
                console.log(data);
                // console.log($("#voucher-uv").data("price"));

            }
        });
    });
});

// Delete Voucher
function removeDiv(id) {
    var kvoucher = $(id).find('input[type=text]').val();
    request = $.ajax({
        url: "/api/voucher/cekvoucher",
        type: "post",
        data: {
            kode_voucher: kvoucher
        },
        success:function(data) {
            var str = $('#dumpkv').html();
            $('#dumpkv').html(str.replace(kvoucher, ""));
            var values = parseInt($('#ptvc').html().replace(/,/g, "")) - parseInt(data['data']['nominal']);
            $('#ptvc').html(values.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"));
        }
    });
    $(id).remove();
}
$('#voucher-uv').click(function(){
    console.log($('#dumpkv').html());

});

// Cek Biaya Tambahan
function biayaTambahan(){
    request = $.ajax({
        url: "/api/jamaah/biayatambahan",
        type: "post",
        data: {
            tanggal_lahir: $("input[name='tanggal_lahir']").val(),
            mahrom : $("#mahrom").val(),
            pernah_umrah : $("#PU").val(),
            tanggal_umrah : $("input[name='tanggal_umrah']").val()
        },
        success:function(data) {
            $('#asuransi').html(data['asuransi']);
            $('#visa_progressif').html(data['visa_progressif']);
            $('#total').html(data['total']);
        }
    });
}

$(document).ready(function(){

    $('#province').change(function(){
        $('#kabkot > *').remove();
        $.get( "/app/lokasi/kabkot", { id: $('#province').val() } ).done(function( r_data ) {
            $('#select2-kabkot-results').remove();
                console.log(r_data);
                var datac = $.map(
                r_data
                ,function (obj) {
                obj.id = obj.id || obj.city_id;
                obj.text = obj.text || obj.city_name + " - " + obj.type;

                return obj;
                console.log(obj);
            });

            $("#kabkot").select2({
                data: datac
            });
            console.log($('#kabkot').val());
        });

    });

          // Kabkot

    $('#kabkot').change(function(){
        $('#kec > *').remove();

        $.get( "/app/lokasi/kecamatan", { id: $('#kabkot').val() } ).done(function( r2_data ) {
            console.log(r2_data);
            var datacx = $.map(
            r2_data
            , function (objkec) {
                objkec.id = objkec.id || objkec.subdistrict_id;
                objkec.text = objkec.text || objkec.subdistrict_name;

                return objkec;
                console.log(objkec);
            });

            $("#kec").select2({
                data: datacx
            });
        });

    });
});

$(document).ready(function(){
    // TIKET
    $('#lanjutPembayaran').click(function(){
        $('#submit-tiket').submit();
        $(this).prop('disabled', true);
    });

    // PEMBAYARAN DEPOSIT

    $(".abupay-otp").click(function(){
        request = $.ajax({
        url: "/api/transaksi/paket",
        type: "get",
        data: {
            'p' : $(".prm-p").html(),
            'x-kode-kantor' : $(".prm-kk").html(),
            'x-metode-bayar' : "Abuppay",
            'x-kode-bank' : "",
            'x-vouchers' : '',
            'x-bulan' : $(".prm-bln").html(),
            'x-tahun' : $(".prm-th").html(),
            'type' : $(".prm-type").html()
        },
        success:function(data) {
            console.log(data)
        }
        });
    });
});

function TiketChoseTwoFlightOne(id){

    // Pergi
    var gambar = $('.bh1-'+id).html();
    var maskapai_pergi = $('.bh2-'+id).html();
    var maskapai_pulang = $('.bh3-'+id).html();
    var tanggal_pergi = $('.bh4-'+id).html();
    var nama_maskapai = $('.bh5-'+id).html();
    var kode_penerbangan = $('.bh6-'+id).html();
    var jam_pergi = $('.bh7-'+id).html();
    var jam_pulang = $('.bh8-'+id).html();
    $('.t1b1').html(gambar);
    $('.t3b1').html(maskapai_pergi);
    $('.t3b2').html(maskapai_pulang);
    $('.t3b3').html(tanggal_pergi);
    $('.t3b4').html(nama_maskapai);
    $('.t3b5').html(kode_penerbangan);
    $('.t4b1').html(jam_pergi);
    $('.t4b2').html(maskapai_pergi);
    $('.t5b1').html(jam_pulang);
    $('.t5b2').html(maskapai_pulang);

    $('.linker').attr("href", $('.linker').attr("href").replace(/\?(fi=)[0-9]\d+/g, "?fi="+id));

    request = $.ajax({
        url: "/api/tiket/penerbangan/XHR",
        type: "post",
        data: {
            flightid : id
        },
        success:function(data) {
            $("input[name='rndnumb1']").val(data['departures']['price_value']);
            var harga = parseInt($("input[name='rndnumb1']").val()) + parseInt($("input[name='rndnumb2']").val());
            $('.harga').html('RP ' + new Intl.NumberFormat().format(harga));
        }
    });
    

}

function TiketChoseTwoFlightTwo(id){
    var gambar2 = $('.ph1-'+id).html();
    var maskapai_pergi2 = $('.ph2-'+id).html();
    var maskapai_pulang2 = $('.ph3-'+id).html();
    var tanggal_pergi2 = $('.ph4-'+id).html();
    var nama_maskapai2 = $('.ph5-'+id).html();
    var kode_penerbangan2 = $('.ph6-'+id).html();
    var jam_pergi2 = $('.ph7-'+id).html();
    var jam_pulang2 = $('.ph8-'+id).html();
    $('.t1p1').html(gambar2);
    $('.t3p1').html(maskapai_pergi2);
    $('.t3p2').html(maskapai_pulang2);
    $('.t3p3').html(tanggal_pergi2);
    $('.t3p4').html(nama_maskapai2);
    $('.t3p5').html(kode_penerbangan2);
    $('.t4p1').html(jam_pergi2);
    $('.t4p2').html(maskapai_pergi2);
    $('.t5p1').html(jam_pulang2);
    $('.t5p2').html(maskapai_pulang2);

    $('.linker').attr("href", $('.linker').attr("href").replace(/\&(rfi=)[0-9]\d+/g, "&rfi="+id));

    request = $.ajax({
        url: "/api/tiket/penerbangan/XHR",
        type: "post",
        data: {
            flightid : id
        },
        success:function(data) {
            $("input[name='rndnumb2']").val(data['departures']['price_value']);
            var harga = parseInt($("input[name='rndnumb2']").val()) + parseInt($("input[name='rndnumb1']").val());
            $('.harga').html('RP ' + new Intl.NumberFormat().format(harga));
        }
    });
}

// Hotel
function star(a, z){
    var range = a - z;
    console.log(range);
}

$(document).ready(function(){
    $("#destination").select2({
        ajax: {
            url: '/hotel-autocomplete',
            type: "get",
            data: function (params) {
              var query = {
                search: params.term
              }

              // Query parameters will be ?search=[term]&type=public
              return query;
            },
            processResults: function (data) {
                return {
                    results: $.map(data['results']['result'], function (item) {
                        return {
                            text: item.value,
                            id: item.label
                        }
                    })
                };
            }
        }
    });
});


// |====================================|
// |        FOR MOBILE SCRIP ONLY       |
// |====================================|