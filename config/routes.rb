 Rails.application.routes.draw do

  #|-----------------------------------------------------------------|
  #|                      Routing For redirect apps                  |
  #|-----------------------------------------------------------------|

  get '/about-us-apps',                                     to: 'redirect_apps#aboutApps'
  get '/terms-and-conditions-apps',                         to: 'redirect_apps#termsApps'
  get '/privacy-policy-apps',                               to: 'redirect_apps#privacyApps'

  get '/penambahan-biaya',                                  to: 'layouts#penambahanbiaya'

  #|-----------------------------------------------------------------|
  #|                      Routing For refund                         |
  #|-----------------------------------------------------------------|

  get '/terms-and-conditions-refund/:no_trans',             to: 'accounts#TermsConditions'
  get '/formulir-refund/:no_trans',                         to: 'accounts#FormulirRefund'
  get '/invoice-refund/:no_trans_refund',                   to: 'accounts#InvoiceRefund'
  get '/verifikasi-otp-refund/:no_trans_refund',            to: 'accounts#OtpRefund'
  get '/resend-verifikasi-otp-refund/:no_trans_refund',     to: 'accounts#ResendOtpRefund'
  get '/transaksi-refund',                                  to: 'accounts#TransaksiRefund'

  get '/pengajuan-penambahan-biaya',                        to: 'accounts#pengajuan'
  # get '/detail-pengajuan',                                  to: 'accounts#detailpengajuan'

  get '/daftar-penambahan-biaya-paket-umrah',               to: 'accounts#daftarpenambahanbiaya'
  get '/pilih-kategori-penambahan-biaya/',                   to: 'accounts#pilihpenambahanbiaya'
  get '/penambahan-biaya-paket-umrah',                      to: 'accounts#penambahanbiaya'

  get '/history-pembahan-biaya',                            to: 'accounts#historypenambahanbiaya'

  #|-----------------------------------------------------------------|
  #|                      Routing For UI mobile                      |
  #|-----------------------------------------------------------------|

  get '/approval-paket-umrah',                              to: 'mobile#mapprovalumrah'
  get '/approval-paket-umrah/:id_produk',                   to: 'mobile#mapprovalumrahh'
  get '/approval-paket-haji/:id_produk',                    to: 'mobile#mapprovalhaji'

  get '/m/login',                                           to: 'mobile#mlogin' # oke tinggal by provider
  get '/m/registers',                                       to: 'mobile#mRegisters'

  # get '/m/reset-pass',                                      to: 'mobile#mresetpass'
  get '/m/otp-pass',                                        to: 'mobile#motppass'
  get '/m/forgot-pass',                                     to: 'mobile#mforgotpass'

  get '/m/payment-data-buyer',                              to: 'mobile#mpaymentumrahdatabuyer' # oke tinggal voucher
  get '/m/payment-tagihan',                                 to: 'mobile#mpaymentumrahbill'

  get '/m/otp-deposit/:no_trans',                           to: 'mobile#otpdepositmobile'

  get 'm/invoice',                                          to: 'mobile#invoicemobile'

  #|-----------------------------------------------------------------|
  #|                      Routing For mobile end                     |
  #|-----------------------------------------------------------------|

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  match "/422", :to => "errors#internal_server_error", :via => :all

  match '/u/:nama_toko/konfirmasi(/:kode_booking)', :to => 'tokoagen#konfirmasipembelianpaketagen', :via => [:get, :post]
  match '/u/:nama_toko/:kode_paket', :to => 'landing#toko_agen', :via => :get
  match '/u/:nama_toko', :to => 'landing#toko_agen', :via => :get
  match '/detail-paket/:nama_toko/:kode_paket/:seo_paket', :to => 'tokoagen#detailproductoko', :via => :get

  #|-----------------------------------------------------------------|
  #|                      Routing For UI new                         |
  #|-----------------------------------------------------------------|

  #get '/ui-search-flight',                        to: 'ownerships#uisearchflight'
  get '/hotel',                                   to: 'hotel#index'
  get '/cari-hotel',                              to: 'hotel#cari_hotel'
  post '/cari-hotel-js',                           to: 'hotel#cari_hotel_js'
  get '/searching-hotel',                         to: 'hotel#listhotel'
  get '/rincian-hotel/(:provinsi)/(:kota)/(:nama_hotel)',                           to: 'hotel#detailhotel'
  get '/hotel-autocomplete',                       to: 'hotel#autocomplete'
  post 'cari-hotel-detail',                        to: 'hotel#cariDetailHotel'

  #|-----------------------------------------------------------------|
  get '/umrah',                                   to: 'ui#umrah'
  get '/haji',                                    to: 'ui#haji'
  get '/flight',                                  to: 'ui#flight'
  get '/beli-pulsa',                              to: 'ui#belipulsa'
  get '/beli-paketdata',                          to: 'ui#belipaketdata'
  get '/beli-tokenlistrik',                       to: 'ui#belitokenlistrik'
  get '/beli-vouchergame',                        to: 'ui#belivouchergames'


  get '/syarat-dan-ketentuan',                    to: 'kebijakan#syaratketentuan'
  get '/kebijakan-privasi',                       to: 'kebijakan#kebijakanprivasi'

  #|-----------------------------------------------------------------|
  #|                  Routing For Ownerships                         |
  #|-----------------------------------------------------------------|

  get '/ownerships',                              to: 'ownerships#ownerships'
  get '/manajemen-paket',                         to: 'ownerships#manajemenpacket'
  get '/create-packet/:notrans',                  to: 'ownerships#createpacket'
  get '/edit-packet/:kdpaket',                    to: 'ownerships#editpacket'
  get '/paket-saya',                              to: 'ownerships#packetowner'
  get '/paket-saya/:notrans',                     to: 'ownerships#detailpacketowner'
  get '/detail-paket-jualan',                     to: 'tokoagen#detailproductoko'
  get '/daftar-penjualan',                        to: 'ownerships#penjualan'
  get '/history-penjualan',                       to: 'ownerships#history_penjualan'
  get '/date-seat/:kdbooking/:kdpaket/:kdkantor', to: 'ownerships#dateseat'
  get '/date-seat/:kdbooking/:kdpaket/:kdkantor/:bln/:thn',            to: 'ownerships#dateseatBytgl'
  get 'delsession',                               to: 'ownerships#deletesession'

  get '/form-pemesanan-toko/:nama_toko/:kode_paket/', to: 'payment#formtoko'
  get '/semua-pesanan-paket',                     to: 'ownerships#pesananpaket'
  get '/history-pesanan',                         to: 'ownerships#historypesanan'

  get '/pengaturan-toko',                         to: 'ownerships#profil_toko'
  post '/update-toko',                            to: 'api/account/toko#create_or_update_toko'
  get '/pengaturan-domain',                       to: 'ownerships#profil_ownership'

  post '/konfirmasi_pesanan',                     to: 'ownerships#konfirmasi_pesanan'

  get '/pengaturan-site-ownerships',              to: 'ownerships#pengaturansite'

  get '/toko-agen',                               to: 'tokoagen#tokoagen'

  get '/konfirmasi-pembayaran',                   to: 'tokoagen#konfirmasipembelianpaketagen'

  #|-----------------------------------------------------------------|
  #|                  Routing For Paket Haji                         |
  #|-----------------------------------------------------------------|

  get '/paket-haji',                              to: 'haji#pakethaji'
  get '/paket-haji/:kode_produk/:kode_kantor/:tahun/:bulan/:nama_seo',      to: 'haji#detail'
  get '/detail-paket-haji',                       to: 'haji#detailpakethaji'

  get '/transaksi-haji',                          to: 'haji#transaksihaji'
  get '/history-transaksi-haji',                  to: 'haji#historytransaksihaji'


  #|-----------------------------------------------------------------|
  #|                  Routing For Naurah                             |
  #|-----------------------------------------------------------------|

  get '/naurah',                                  to: 'naurah#naurah'
  get '/naurah-customer',                         to: 'naurah#naurahcustomer'
  get '/naurah-detail',                           to: 'naurah#naurahdetail'
  get '/detail-naurah-customer',                  to: 'naurah#naurahcustomerdetail' # hapus

  get '/pembayaran-naurah',                       to: 'naurah#pembayarannaurah'
  get '/history-pembayaran-naurah',               to: 'naurah#historypembayarannaurah'

  #|-----------------------------------------------------------------|
  #|                                                                 |
  #|-----------------------------------------------------------------|
  
  get '/download',                                to: 'download#download'

  get '/',                                        to: 'landing#home'
  get '/abutours',                                to: 'landing#home'
  get '/about-us',                                to: 'landing#tentang'
  get '/services/umrah',                          to: 'landing#layananumrah'

  get '/paket-umrah',                             to: 'umrah#packet'
  get '/paket-umrah-murah',                       to: 'umrah#packet'

  get '/detil-paket/:kode',                       to: 'umrah#detailpacket'
  get '/detil-paket/:kode/:kk/:th/:bln/:seo',     to: 'umrah#detailpacket'

  get '/paket-umrah/:kota/paket-umrah-di-kota-:nama_kota',    to: 'umrah#packet'
  get '/paket-umrah-tahun-:tahun',                to: 'umrah#packet'
  get '/paket-umrah/:bulan/paket-umrah-:nama_bulan',   to: 'umrah#packet'
  get '/paket-umrah/paket-:paket',                to: 'umrah#packet'


  get '/abustore',                                to: 'store#homestore'
  get '/abustore-produk',                         to: 'store#store'
  get '/detil-produk',                            to: 'store#detailstore'
  get '/keranjang-belanja',                       to: 'store#cart'

  get '/partnerships',                            to: 'landing#partnership'
  get '/daftar-partnerships-abutours',            to: 'landing#formpartnership'
  get '/blog',                                    to: 'landing#blog'
  get '/blog-detil/:id/:judul_seo',               to: 'landing#blogdetil'
  get '/faq',                                     to: 'landing#faq'

  get '/email-verifikasi',                        to: 'email#verifikasi'
  get '/email-invoices',                          to: 'email#invoices'
  get '/tiket-umrah',                             to: 'email#tiketumrah'
  get '/email-Eticket',                           to: 'email#EticketEmail'
  get '/etiket-jamaah',                           to: 'email#eticketnew'
  get '/etiket/:kode_tiket-:sambarang.pdf',       to: 'email#eticketnew_pdf'

  get '/email-konfirmasi-agen',                   to: 'email#konfirmasiagen'

  get '/e-booking',                               to: 'email#ebooking'
  get '/e-booking/:kode_booking-:stupid_hash.pdf',to: 'email#ebooking_pdf'

  get '/error/500',                               to: 'errors#problems'
  get '/error/404',                               to: 'errors#pageerror'
  get '/maintenance',                             to: 'errors#maintenance'

  get '/data-pembelian',                          to: 'payment#formpembelian'
  get '/form-pemesanan-paket/:id_produk',         to: 'payment#formpemesanan'
  get '/form-pemesanan-tiket',                    to: 'payment#datapemesanantiket'
  get '/input-data-jamaah',                       to: 'payment#inputdatajamaah'
  get '/pilih-metode-pembayaran',                 to: 'payment#metodepembayaran'
  get '/pilih-metode-pembayaran/tiket',           to: 'payment#metodepembayarantiket'
  get '/metode-pembayaran',                       to: 'payment#metode'
  get '/metode-pembayaran-langsung',              to: 'payment#pembayaranlangsung'
  get '/metode-pembayaran-abupay',                to: 'payment#pembayarantransfer'
  get '/tagihan-pembayaran',                      to: 'payment#tagihanpembayaran'
  get '/verifikasi-pembayaran/:kode',             to: 'payment#otpdeposit'

  get '/data-pemesan',                            to: 'payment#pemesananhotel'

  get '/mutasi-deposit',                          to: 'accounts#mutasideposit'

  # -- panel accounts customer --
  get 'accounts',                                 to: 'accounts#dashboard'
  get 'accounts/dashboard',                       to: 'accounts#dashboard'
  get 'accounts/informasi',                       to: 'accounts#informasi'

  get '/konfirmasi-pembayaran/:kode',             to: 'accounts#konfirmasipembayaran'
  get '/terima-kasih',                            to: 'accounts#thanks'

  get '/tambah-saldo-abupay',                     to: 'accounts#topup'
  get '/tambah-saldo-abupay/:id/tagihan',         to: 'accounts#topupTagihan'
  get '/transaksi-abupay',                        to: 'accounts#transaksitopup'

  get '/saldo-priority',                          to: 'accounts#priority'

  get '/paket-agen',                              to: 'accounts#paketagen'
  get '/syarat-ketentuan/:id_produk',             to: 'accounts#syaratketentuan'

  get '/daftar-paket-b2c',                        to: 'accounts#daftarpaket'
  get '/detil-paket-b2c/:kode',                   to: 'accounts#detilpaket'

  get '/account/paket-haji',                                                        to: 'haji#account_index'
  get '/account/paket-haji/:kode_produk/:kode_kantor/:tahun/:bulan/:nama_seo',      to: 'haji#account_detail'

  get '/data-bank',                               to: 'accounts#databank'
  get '/tambah-data-bank',                        to: 'accounts#addbank'
  get '/edit-data-bank/:id',                      to: 'accounts#editbank'

  get '/pembayaran-umrah',                        to: 'accounts#pembayaranpacket'
  get '/pembayaran-umrah/:kode_transaksi',        to: 'accounts#pembayaran_paket_detail'

  get '/transaksi-umrah',                         to: 'accounts#transaksiumrah'
  get '/transaksi-halal-tours',                   to: 'accounts#transaksihalaltours'
  get '/transaksi-tiket',                         to: 'accounts#pembeliantiket'
  get '/transaksi-souvenir',                      to: 'accounts#transaksisouvenir'
  get '/detailorder-souvenir',                    to: 'accounts#detailsouvenir'

  # ppob pulsa
  get '/pulsa',                                   to: 'ppob_pulsa#index'
  post '/pulsa/detail',                           to: 'ppob_pulsa#detail'
  # ppob pulsa api
  get '/pulsa/inquiry/:id',                       to: 'ppob_pulsa#inquiry'
  get '/pulsa/inquiry-new/:id',                       to: 'ppob_pulsa#inquiryNew'
  get '/pulsa/inquiry-news/:id',                       to: 'ppob_pulsa#inquiryNews'
  post '/pulsa/beli',                             to: 'ppob_pulsa#beli'

  get '/evoucher/beli/:id',                       to: 'ppob_all#beliDetailMetode'
  get '/evoucher/beli/:id/ABUPAY',                to: 'ppob_all#metodeAbupay'
  get '/evoucher/beli/:id/ABUPAY/otp',            to: 'ppob_all#metode_abupay_otp'
  get '/evoucher/beli/:id/TRANSFER',              to: 'ppob_all#metode_transfer'
  post '/evoucher/bank',                          to: 'ppob_all#tambahBank'
  get '/evoucher/beli/:id/invoice',               to: 'ppob_all#invoice'
  get '/evoucher/beli/:id/tagihan',               to: 'ppob_all#tagihan'
  get '/evoucher/beli/:id/konfirmasi',            to: 'ppob_all#konfirmasi'
  post '/evoucher/beli/:id/konfirmasi',           to: 'ppob_all#konfirmasiPembayaran'
  post '/evoucher/beli/:id/konfirmasi-abupay',           to: 'ppob_all#konfirmasiPembayaranAbupay'

  get '/paket-data',                              to: 'ppob_paket#index'
  get '/paket-data/inquiry-old/:id',                       to: 'ppob_paket#inquiryOld'
  get '/paket-data/inquiry/:id',                       to: 'ppob_paket#inquiry'
  get '/paket-data/inquiry-news/:id',                       to: 'ppob_paket#inquiryNews'
  post '/paket-data/detail',                      to: 'ppob_paket#detail'
  post '/paket-data/beli',                        to: 'ppob_paket#beli'

  get '/token-listrik',                           to: 'ppob_pln#index'
  get '/token-listrik/inquiry/:id',                       to: 'ppob_pln#inquiryPrepaid'
  get '/token-listrik/inquiry-new/:id',                       to: 'ppob_pln#inquiryPrepaid'
  post '/token-listrik/detail',                   to: 'ppob_pln#detail'
  post '/token-listrik/beli',                     to: 'ppob_pln#beli'

  get '/voucher-game',                            to: 'ppob_game#index'
  post '/voucher-game/detail',                    to: 'ppob_game#detail'
  post '/voucher-game/beli',                      to: 'ppob_game#beli'
  get '/voucher-game/inquiry/:id',                to: 'ppob_game#inquiry'
  get '/voucher-game/inquiry-new/:id',                to: 'ppob_game#inquiryNew'

  get '/bpjs-kesehatan',                          to: 'accounts#bpjskesehatan'
  get '/detail-pembelian-evoucher',               to: 'accounts#detailevoucher'
  get '/tagihan-evoucher',                        to: 'accounts#tagihanevoucher'

  # evoucher
  get '/fitur-tiket-pesawat',                     to: 'evoucher#tiketpesawat'
  get '/pencarian-tiket-ppin',                    to: 'evoucher#searchingticket_s1'
  get '/pencarian-tiket-pp',                      to: 'evoucher#searchingticket_s2'

  get '/pencarian-tiket',                         to: 'ppob_pesawat#pencarian_landing'

  get '/evoucher/pulsa',                          to: 'evoucher#pulsa'
  get '/evoucher/paketdata',                      to: 'evoucher#paketdata'
  get '/evoucher/tokenlistrik',                   to: 'evoucher#tokenlistrik'
  get '/evoucher/vouchergame',                    to: 'evoucher#vouchergame'

  # ari
  post '/detail-pembelian-evoucher',              to: 'accounts#detailevoucherPost'
  post '/pembelianVoucher',                       to: 'accounts#pembelianVoucher'

  get '/transaksi-evoucher',                      to: 'accounts#transaksievoucher'

  get '/pengaturan-akun-profile',                 to: 'accounts#editprofile'
  get '/pengaturan-akun-profile/:type',           to: 'accounts#edit_profile_type'

  get '/pengaturan-password',                     to: 'accounts#ubahpassword'
  get '/pengaturan-password-otp',                 to: 'accounts#otpubahpassword'

  get '/upgrade-akun',                            to: 'accounts#home'
  get '/berkas-formulir-upgrade-akun',            to: 'accounts#formupgrade'

  get '/add-jamaah/:kode',                        to: 'accounts#addjamaah'
  get '/data-jamaah',                             to: 'accounts#datajamaah'
  post '/data-jamaah',                            to: 'accounts#datajamaah'

  get '/manifest-bus',                            to: 'accounts#manifestbus'
  get '/manifest-hotel',                          to: 'accounts#manifesthotel'

  get '/pengaturan-seat',                         to: 'accounts#seat'
  get '/transfer-seat/:kode',                     to: 'accounts#transferseat'
  get '/riwayat-transfer-seat',                   to: 'accounts#riwayatseat'

  # kcp
  get '/pengaturan-seat-kcp',                     to: 'accounts#seatKcp'
  get '/pengaturan-seat-markup/:kdbook/:kdproduk/:kdkantor',                  to: 'accounts#seatmarkup'
  # get '/pengaturan-seat-jamaah',                  to: 'accounts#kcpaddjamaah'
  post '/pengaturan-seat-jamaah/:kdbook/:kdproduk/:kdkantor',                  to: 'accounts#kcpaddjamaah'
  get '/history-penggunaan-seat-kcp',             to: 'accounts#historykcp'

  get '/beli-voucher',                            to: 'accounts#addvoucher'
  get '/voucher-saya',                            to: 'accounts#daftarvoucher'
  get '/semua-transaksi-voucher',                 to: 'accounts#riwayatvoucher'

  get '/tukar-poin',                              to: 'accounts#poin'
  get '/transaksi-tukar-poin',                    to: 'accounts#transaksipoin'

  get '/fee',                                     to: 'fee#index'
  get '/fee/pasif',                               to: 'fee#fee_pasif'
  get '/fee/transaksi',                           to: 'fee#transaksi_fee'

  get '/fee/pencairan',                           to: 'fee#pencairan'
  get '/fee/transaksi-pencairan',                 to: 'fee#transaksi_pencairan'
  post '/fee/pencairan',                          to: 'fee#aksi_pencairan'

  get '/invoices',                                to: 'accounts#invoices'

  # -- panel notification --
  get '/informasi',                               to: 'accounts#notification'
  post '/informasi/update_status',                to: 'api/account/notifikasi#update_notifikasi'

  # -- panel login user --
  get '/abutours-login',                          to: 'auth#login'

  # -- panel registers user --
  match '/abutours-registers',                    to: 'auth#registers', :via => [:get,:post]

  # -- panel reset password --
  get 'auth/resetpassword'

  # -- panel routes tiket pesawat
  get '/tiket-pesawat',                           to: 'ppob_pesawat#index'
  get '/tiket-pesawat/book',                      to: 'ppob_pesawat#book'
  get '/tiket-pesawat/detail',                    to: 'ppob_pesawat#detail'
  get '/daftar-penerbangan-p1',                   to: 'ppob_pesawat#ticketone'
  get '/tiket-pesawat/pencarian',                 to: 'ppob_pesawat#pencarian'
  get '/e-ticket/:kode',                          to: 'ppob_pesawat#eticket'
  get '/e-ticket/pdf/:kode_booking-:tipe-:hash.pdf',  to: 'ppob_pesawat#eticket_pdf'

  get '/pencarian-double-flight',                 to: 'accounts#searchticketwo'

  # -- panel root user --
  #root 'layouts#beranda'
  # root 'landing#home'

  #|-----------------------------------------------------------------|
  #|                      Routing For API                            |
  #|-----------------------------------------------------------------|

  get 'api/register',                             to: 'api/auth/auth#register'

  scope 'api' do
    # Auth
    post 'login',                                 to: 'api/auth/auth#login'
    post 'login-verifikasi',                      to: 'api/auth/auth#loginVerifikasi'
    post 'register',                              to: 'api/auth/auth#register'
    post 'register-verifikasi',                   to: 'api/auth/auth#registerVerifikasi'

    # Reset Password
    post 'send-reset-password-number-otp',        to: 'api/auth/reset_password#getNumberPhone'
    post 'confirm-otp',                           to: 'api/auth/reset_password#confirmOtp'
    post 'reset-password',                        to: 'api/auth/reset_password#reset'

    post 'ubah-password',                         to: 'api/auth/reset_password#ubahPassword'

    # Bank
    get 'data-bank/:id',                          to: 'api/account/bank#detail'
    post 'data-bank',                             to: 'api/account/bank#addBank'
    post 'data-bank-update',                      to: 'api/account/bank#updateBank'
    delete 'data-bank-remove/:id',                to: 'api/account/bank#removeBank'

    # Account
    get 'pakets',                                 to: 'api/account/paket_umrah#rendering'
    post 'profil-update',                         to: 'api/account/user_profil#updateProfil'
    post 'profil-update-pembelian',               to: 'api/account/user_profil#update_profiPembelian'
    post 'profil-update-photo',                   to: 'api/account/user_profil#updateProfilPhoto'
    post 'profil-update-mobile',                  to: 'api/account/user_profil#update_profil_mobile'
    post 'jamaah-info',                           to: 'api/account/user_profil#infoJamaah'
    post 'alamat-update',                         to: 'api/account/user_profil#update_alamat'

    # Profile Change Number
    post 'change-number',                         to: 'api/account/user_profil#change_number'
    post 'confirm-change-number',                 to: 'api/account/user_profil#confirm_change_number'
    get 'change-number-resend-otp',               to: 'api/auth/otp#send_change_number_otp'

    # Profile Change Email
    post 'change-email',                          to: 'api/account/user_profil#change_email'

    # Paket
    post 'pencarian-umrah',                       to: 'api/account/paket_umrah#pencarianHomePage'

    # Transaksi
    get 'transaksi/paket',                        to: 'api/account/transaksi#pembelianPaket'
    get 'transaksi/tiket',                        to: 'api/account/transaksi#metodePembayaranTiket'
    post 'transaksi/konfirmasi',                  to: 'api/account/transaksi#konfirmasiPembayaran'
    post 'transaksi/abupay',                      to: 'api/account/transaksi#abupayDeposit'
    post 'transaksi/abupay/otp/:kode_paket',      to: 'api/account/transaksi#konfirmasiTransaksiPaketAbupay'
    post 'transaksi/konfirmasi/abupay',           to: 'api/account/transaksi#konfirmasiTopUpAbupay'
    post 'transaksi/konfirmasi/tiket',            to: 'api/account/transaksi#konfirmasiTiket'

    # Voucher
    post 'voucher/cekvoucher',                    to: 'api/account/voucher#checkVoucher'
    post 'voucher/cekvoucher/single',             to: 'api/account/voucher#checkDoubleVoucher'
    post 'voucher/session',                        to: 'api/account/voucher#voucherSession'

    #Jamaah
    post 'jamaah/seat',                           to: 'api/account/jamaah#seatDataJamaah'
    post 'jamaah/biayatambahan',                  to: 'api/account/jamaah#biayaTambahan'
    post 'jamaah/seatkcp',                        to: 'api/account/jamaah#seatDataJamaahkcp'

    #Transfer Seat
    post '/transfer-seat',                        to: 'api/account/seat#transfer'
    post '/confirm-transfer-seat',                to: 'api/account/seat#confirm_transfer_seat'
    get '/trasfer-seat-resend-otp',               to: 'api/auth/otp#send_transfer_seat_otp'

    #Poin
    get 'poin/tukar/:id_reward',                  to: 'api/account/poin#tukarPoin'

    # Fee
    get 'fee/otp',                                to: 'api/account/fee#otp'
    post 'fee/konfirmasi',                        to: 'api/account/fee#konfirmasi_otp'

    #Tiket
    post 'tiket/pencarian/penerbangan',           to: 'api/account/tiket_pesawat#pencarianMaskapai'
    post 'tiket/order',                           to: 'api/account/tiket_pesawat#registrasiPenumpang'
    post 'tiket/penerbangan/XHR',                 to: 'api/account/tiket_pesawat#XHRinfoPenumpang'

    get 'deposit/get-otp',                        to: 'api/payment/evoucher#getDepositOtp'
    get 'deposit/otp',                            to: 'api/payment/evoucher#confirmDepositOtp'
    post 'tiket/check-updated-flights',            to: 'api/account/tiket_pesawat#check_updated_flights'

    #ownership
    post 'create-paket',                          to: 'api/account/ownership#createPaket'
    post 'pengaturan-site',                       to: 'api/account/ownership#pegaturanSite'
    post 'update-paket/:kdpaket',                 to: 'api/account/ownership#updatePaket'
    post 'ownership/approval',                    to: 'api/account/ownership#aprroval'

    # Refund
    post 'refund-paket',                          to: 'api/account/refund#refundAction'
    post 'refund-otp-confirmation',                to: 'api/account/refund#OtpRefundConfirmation'

    # Maklumat
    post 'maklumat/pengajuan',                    to: 'api/account/maklumat#maklumatPengajuan'
    post 'maklumat/add-jamaah',                   to: 'api/account/maklumat#maklumatAddJamaah'
  end

  scope 'app' do
    # Auth
    get 'login-otp',                              to: 'api/auth/auth#loginOtp'
    get 'register-otp',                           to: 'api/auth/auth#registerOtp'
    get 'logout',                                 to: 'api/auth/auth#removeAndRevoke'
    get 'send-otp/login',                         to: 'api/auth/otp#sendOtpLogin'
    get 'send-otp/register',                      to: 'api/auth/otp#sendOtpRegister'

    # Reset Password
    get 'reset-password-number',                  to: 'api/auth/reset_password#renderNumberPhone'
    get 'reset-password-otp',                     to: 'api/auth/reset_password#renderOtp'
    get 'reset-password-resend-otp',              to: 'api/auth/reset_password#resendOtp'
    get 'reset-password',                         to: 'api/auth/reset_password#renderReset'

    # Lokasi Provinsi, Kabupaten/Kota, Kecamatan
    scope 'lokasi' do
      get 'provinsi',                             to: 'api/account/lokasi#renderProvinsi'
      get 'kabkot',                               to: 'api/account/lokasi#renderKabKotByProvinsi'
      get 'kecamatan',                            to: 'api/account/lokasi#renderKecByKabkot'
    end

    # Tiket
    get 'tiket/invoice/:kode',                          to: 'api/account/tiket_pesawat#invoiceTiket'
    get 'tiket/invoice/bank-transfer/:kode',            to: 'api/account/tiket_pesawat#invoiceTiket'

    # Paket
    get 'umrah/invoice/:kode',                          to: 'api/account/paket_umrah#invoicePaket'

    # KCP
    get 'kcp/invoice/:kcptrans',                             to: 'accounts#invoicekcp'

    # Paket Ownership
    post 'ownership/pemesanan/:kode_paket',                          to: 'api/account/ownership#formPemesananToko'


    # Testing
    get 'ses', to: 'api/testing#ses'
    get 'tkn', to: 'application#Authentication'
    get 'prd', to: 'api/account/paket_umrah#rendering'
    get 'bank', to: 'api/account/bank#addBank'
    get 'test', to: 'application#test'
    get 'tiket', to: 'api/testing#tiket'
    get 'dumper', to: 'api/testing#dumperCode'
  end

  get 'otp', to: 'api/testing#sesotp'


  # Sosmed
  match 'auth/:provider/callback', to: 'api/auth/sosmed/sessions#create', via: [:get, :post]
  match 'auth/failure', to: 'api/auth/sosmed/sessions#failure' , :via => [:get, :post]
  match 'auth/login', to: 'api/auth/sosmed/auth#login', via: [:get, :post]
  match 'auth/registers', to: 'api/auth/sosmed/auth#registers', via: [:get, :post]
  match 'auth/verify', to: 'api/auth/sosmed/auth#verify', via: [:get, :post]
  match 'auth/logout', to: 'api/auth/sosmed/auth#destroy', via: [:get, :post]

  get 'tiket-umrah2', to: 'email#tiket2'
  # get 'test_email', to: 'email#tes_kirim_email'
  post 'tiket/api_send_email_etiket',            to: 'email#api_send_email_etiket'

  # sembunyikan Routing Error
  get 'developer-team',                          to: 'api/testing#developerTeam'
  match ":url" => "application#redirect_user", :constraints => { :url => /.*/ }, via: [:all]
end