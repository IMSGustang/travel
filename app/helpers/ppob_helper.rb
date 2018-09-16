module PpobHelper
  require 'rest-client'

  def self.history(token)
    res = JSON.parse(RestClient.get api_url + 'all/history', {
        "Authorization" => "Bearer #{token}"
    })
    return res
  end

  def self.historyNew(token, filter)
    res = JSON.parse(RestClient.get api_url + 'history', {
        "Authorization" => "Bearer #{token}",
        'x-filter' => filter,
    })
    return res
  end

  def self.historyDetail(request, token)
    # id = request[:id]
    # res = JSON.parse(RestClient.get api_url + 'history/' + , {Authorization: "Bearer #{token}"})
    jason = '{
        "id": null,
        "status": 0,
        "kodeTransaksi": "ABU217762",
        "kodeTipe": "TIP001",
        "namaTipe": "Pulsa",
        "jenisVoucher": "XL",
        "nominal": "10.000",
        "nominalTransfer": 10800,
        "tanggalTransaksi": "2017-09-30T15:30:51.000Z",
        "statusBakoel": "BELUM",
        "jenisPembayaran": "Bank Transfer",
        "bankTujuan": {
        	"namaBank": "Mandiri",
        	"nomorRekening":"1330012939500",
        	"cabang":"Mampang",
        	"atasNama":"PT. Amanah Bersama Ummat"
        },
        "bankPengirim":{
        	"namaBank": "Mandiri",
        	"nomorRekening":"1330012939500",
        	"cabang":"Makassar",
        	"atasNama":"Gustang Blammats"
        }
    }'
    return JSON.parse(jason)
  end

  def self.api_url
    # url = ENV['PPOB_API_URL']
    url = VariableHelper.api_url_ppob
  end
end
