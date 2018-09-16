class mobileResetPass extends React.Component {
    render() {
        return (
            <div className="data-reset-pass">
                <nav className="navbar navbar-back navbar-light">
                    <a className="navbar-brand" href="/m/login">
                        <i className="ion-ios-arrow-thin-left"></i>
                    </a>
                </nav> {/* end navbar */}

                <div className="card">
                    <div className="card-header">
                        <h5 className="mb-1">
                            Reset Password
                        </h5>
                        <p className="mb-0">
                            Buat password baru anda disini, Persyaratan minimal 6 karakter. Buat password anda se-unik mungkin
                        </p>
                    </div>

                    <div className="card-body">
                        <div className="form-group">
                            <label>Password Baru</label>
                            <div className="input-group">
                                <div className="input-group-prepend">
                                    <span className="input-group-text">
                                        <img src="/assets/mobile/icons/users/password_2.png" />
                                    </span>
                                </div>
                                <input type="password" className="form-control" placeholder="" />
                            </div>
                        </div>

                        <div className="form-group">
                            <label>Konfirmasi Password Baru</label>
                            <div className="input-group">
                                <div className="input-group-prepend">
                                    <span className="input-group-text">
                                        <img src="/assets/mobile/icons/users/password_2.png" />
                                    </span>
                                </div>
                                <input type="password" className="form-control" placeholder="" />
                            </div>
                        </div>

                        <div className="form-group">
                            <a href="/m/abutours" className="btn btn-block btn-danger">
                                Simpan
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}