class mobilePaymentBill extends React.Component {
    render() {
        return (
            <div className="data-payment-bill">
                <div className="card">
                    <div className="card-body">
                        <h5 className="mb-0">
                            Bank Tujuan Transfer :
                        </h5>

                        <div className="media">
                            <div className="media-body">
                                <p className="text-info mt-2 mb-0">
                                    MANDIRI - 000 000 000 000 00
                                </p>
                            </div>
                            <img src="/assets/lib/payment-icon/MANDIRI.png" className="align-self-center ml-3" />
                        </div>
                    </div>
                </div>

                <div className="card">
                    <div className="card-header text-center">
                        <p className="text-uppercase mb-2">
                            Batas waktu pembayaran
                        </p>

                        <div className="alert alert-warning" role="alert">
                            Kamis, 1 Januari 2018 Pukul 15:00
                        </div>
                    </div>

                    <div className="card-body">
                        <div className="alert alert-warning" role="alert">
                            Lakukan transfer ke <span className="text-danger">rekening tujuan diatas</span> sesuai TOTAL TAGIHAN ANDA
                            agar tidak menghambat proses verifikasi.
                        </div>

                        <p className="text-muted">
                            Kami akan memproses transaksi anda selambat-lambatnya dalam waktu 1x24 jam setelah anda melakukan
                            <br /><a href="" className="text-danger">Konfirmasi Pembayaran</a>
                        </p>
                    </div>
                </div>
            </div>
        )
    }
}