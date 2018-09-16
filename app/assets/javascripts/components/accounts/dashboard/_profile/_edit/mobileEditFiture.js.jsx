class mobileEditFiture extends React.Component {
    render() {
        return (
            <div className="data-edit-fiture">
                <nav className="navbar navbar-back navbar-light">
                    <a className="navbar-brand" href="">
                        <i className="ion-ios-arrow-thin-left"></i>
                    </a>
                </nav> {/* end navbar */}

                <div className="card card-images">
                    <div className="card-body"></div>
                    <div className="thumbnail">
                        <a href="">
                            <img src="/assets/lib/cover/gustang.png" className="mx-auto d-block" />
                            <i className="ion-ios-camera"></i>
                        </a>
                    </div>
                </div>

                <div className="card card-list">
                    <ul className="list-group">
                        <li className="list-group-item">
                            <a href="/pengaturan-akun-profile/data-pribadi" className="w-100">
                                <div className="media">
                                    <div className="align-self-center mr-2">
                                        <div className="icons-sm icons-datapribadi"></div>
                                    </div>
                                    <div className="media-body">
                                        <h6 className="mb-0">Data Pribadi</h6>
                                        <p className="mb-0">
                                            Ubah informasi data pribadi anda
                                        </p>
                                    </div>
                                    <div className="align-self-center ml-2">
                                        <div className="icons-sm icons-arrow-right"></div>
                                    </div>
                                </div>
                            </a>
                        </li>

                        <li className="list-group-item">
                            <a href="/pengaturan-akun-profile/data-alamat" className="w-100">
                                <div className="media">
                                    <div className="align-self-center mr-2">
                                        <div className="icons-sm icons-address"></div>
                                    </div>
                                    <div className="media-body">
                                        <h6 className="mb-0">Alamat</h6>
                                        <p className="mb-0">
                                            Ubah informasi alamat anda
                                        </p>
                                    </div>
                                    <div className="align-self-center ml-2">
                                        <div className="icons-sm icons-arrow-right"></div>
                                    </div>
                                </div>
                            </a>
                        </li>

                        <li className="list-group-item">
                            <a href="/data-bank" className="w-100">
                                <div className="media">
                                    <div className="align-self-center mr-2">
                                        <div className="icons-sm icons-rekening"></div>
                                    </div>
                                    <div className="media-body">
                                        <h6 className="mb-0">Rekening Bank</h6>
                                        <p className="mb-0">
                                            Ubah informasi rekening
                                        </p>
                                    </div>
                                    <div className="align-self-center ml-2">
                                        <div className="icons-sm icons-arrow-right"></div>
                                    </div>
                                </div>
                            </a>
                        </li>

                        <li className="list-group-item">
                            <a href="/pengaturan-akun-profile/nomor-telepon" className="w-100">
                                <div className="media">
                                    <div className="align-self-center mr-2">
                                        <div className="icons-sm icons-telepon"></div>
                                    </div>
                                    <div className="media-body">
                                        <h6 className="mb-0">Telepon</h6>
                                        <p className="mb-0">
                                            Ubah informasi no telepon anda
                                        </p>
                                    </div>
                                    <div className="align-self-center ml-2">
                                        <div className="icons-sm icons-arrow-right"></div>
                                    </div>
                                </div>
                            </a>
                        </li>

                        <li className="list-group-item">
                            <a href="/pengaturan-akun-profile/akun-email" className="w-100">
                                <div className="media">
                                    <div className="align-self-center mr-2">
                                        <div className="icons-sm icons-email"></div>
                                    </div>
                                    <div className="media-body">
                                        <h6 className="mb-0">Email</h6>
                                        <p className="mb-0">
                                            Ubah informasi email anda
                                        </p>
                                    </div>
                                    <div className="align-self-center ml-2">
                                        <div className="icons-sm icons-arrow-right"></div>
                                    </div>
                                </div>
                            </a>
                        </li>

                        <li className="list-group-item">
                            <a href="/pengaturan-password" className="w-100">
                                <div className="media">
                                    <div className="align-self-center mr-2">
                                        <div className="icons-sm icons-password"></div>
                                    </div>
                                    <div className="media-body">
                                        <h6 className="mb-0">Password</h6>
                                        <p className="mb-0">
                                            Ubah informasi password anda
                                        </p>
                                    </div>
                                    <div className="align-self-center ml-2">
                                        <div className="icons-sm icons-arrow-right"></div>
                                    </div>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        )
    }
}