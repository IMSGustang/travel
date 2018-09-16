class mobileOtpPass extends React.Component {
    componentDidMount() {
        $.autotab({ tabOnSelect: true });
        $('.kode').autotab('filter', 'kode');
    }

    render() {
        return (
            <div className="data-otp-pass">
                <nav className="navbar navbar-back navbar-light">
                    <a className="navbar-brand" href="/m/forgot-pass">
                        <i className="ion-ios-arrow-thin-left"></i>
                    </a>
                </nav>
                {/* end navbar */}

                <div className="card">
                    <div className="card-header">
                        <h5 className="mb-1">
                            Konfirmasi Kode Keamanan
                        </h5>
                        <p className="mb-0">
                            Kami telah mengirimkan kode keamanan RESET password akun anda ke nomor <br/>
                            +62 82 345 *** 401
                        </p>
                    </div>

                    <div className="card-body">
                        <div className="form-group">
                            <table className="table table-sm mb-0">
                                <tbody>
                                <tr>
                                    <td><input type="text" className="form-control kode text-uppercase" minLength={1} maxLength={1} /></td>
                                    <td><input type="text" className="form-control kode text-uppercase" minLength={1} maxLength={1} /></td>
                                    <td><input type="text" className="form-control kode text-uppercase" minLength={1} maxLength={1} /></td>
                                    <td><input type="text" className="form-control kode text-uppercase" minLength={1} maxLength={1} /></td>
                                    <td><input type="text" className="form-control kode text-uppercase" minLength={1} maxLength={1} /></td>
                                    <td><input type="text" className="form-control kode text-uppercase" minLength={1} maxLength={1} /></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div className="form-group">
                            <p className="text-center mb-0">
                                Tidak menerima kode ?
                            </p>
                            <p className="text-center mb-0">
                                <a href="" className="text-center text-danger">
                                    Kirim ulang kode
                                </a>
                            </p>
                        </div>

                        <div className="form-group">
                            <a href="/m/reset-pass" className="btn btn-block btn-danger">
                                Konfirmasi
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}