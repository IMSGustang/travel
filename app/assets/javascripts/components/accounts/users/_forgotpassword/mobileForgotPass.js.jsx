class mobileForgotPass extends React.Component {
    render() {
        return (
            <div className="data-forgot-pass">
                <nav className="navbar navbar-back navbar-light">
                    <a className="navbar-brand" href="/m/login">
                        <i className="ion-ios-arrow-thin-left"></i>
                    </a>
                </nav> {/* end navbar */}

                <div className="card">
                    <div className="card-header">
                        <h5 className="mb-1">
                            Lupa Password
                        </h5>
                        <p className="mb-1">
                            Butuh bantuan dengan password anda ?
                        </p>
                        <p className="mb-0">
                            Masukkan email / nomor telepon yang anda gunakan untuk mendaftar, kami akan membantu anda untuk melakukan RESET Password.
                        </p>
                    </div>

                    <div className="card-body">
                        <div className="form-group mb-3">
                            <label>Email / Nomor Telepon</label>
                            <div className="input-group">
                                <div className="input-group-prepend">
                                    <span className="input-group-text">
                                        <img src="/assets/mobile/icons/users/telepon.png" />
                                    </span>
                                </div>
                                <input type="text" className="form-control" placeholder="" />
                            </div>
                        </div>

                        <div className="form-group">
                            <a href="/m/otp-pass" className="btn btn-block btn-danger">
                                Lanjutkan
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}