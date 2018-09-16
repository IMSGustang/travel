class mobileLogin extends React.Component {
    render() {
        return (
            <div className="data-login">
                <nav className="navbar navbar-back navbar-light">
                    <a className="navbar-brand" href="/m/abutours">
                        <i className="ion-ios-arrow-thin-left"></i>
                    </a>
                </nav> {/* end navbar */}

                <div className="card">
                    <div className="card-header">
                        <h5 className="mb-1">
                            Login Ke Akun Abutours Anda
                        </h5>
                        <p className="mb-0">
                            Nikmati segala kemudahan perjalanan ibadah dimulai dari sini.
                        </p>
                    </div>
                    <div className="card-body">
                        <div className="form-group">
                            <label>ID User / Nomor Telepon</label>
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
                            <label>Password</label>
                            <div className="input-group">
                                <div className="input-group-prepend">
                                    <span className="input-group-text">
                                        <img src="/assets/mobile/icons/users/password_2.png" />
                                    </span>
                                </div>
                                <input type="text" className="form-control" placeholder="" />
                            </div>
                            <p className="text-right">
                                <a href="/m/forgot-pass" className="text-danger">
                                    Lupa password ?
                                </a>
                            </p>
                        </div>

                        <div className="form-group mb-4">
                            <a href="/m/myProfile" className="btn btn-block btn-danger">
                                Masuk Sekarang
                            </a>
                        </div>

                        <p className="text-center title-or mb-0">
                            <span>atau</span>
                        </p>
                        <hr />

                        <table className="table table-sm mb-4 mt-4">
                            <tbody>
                            <tr>
                                <td>
                                    <a href="">
                                        <div className="media">
                                            <img src="/assets/lib/icon/fb-logo.png" className="align-self-center mr-2" />
                                            <div className="media-body">
                                                <p className="mb-0">
                                                    Masuk dengan akun facebook
                                                </p>
                                            </div>
                                        </div>
                                    </a>
                                </td>
                                <td>
                                    <a href="">
                                        <div className="media">
                                            <img src="/assets/lib/icon/gg-logo.png" className="align-self-center mr-2" />
                                            <div className="media-body">
                                                <p className="mb-0">
                                                    Masuk dengan akun google
                                                </p>
                                            </div>
                                        </div>
                                    </a>
                                </td>
                            </tr>
                            </tbody>
                        </table>

                        <div className="title-register text-center">
                            <p className="mb-0">
                                Belum Memiliki Akun ?
                            </p>
                            <a href="/m/registers" className="text-danger text-uppercase">
                                Daftar Sekarang
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}