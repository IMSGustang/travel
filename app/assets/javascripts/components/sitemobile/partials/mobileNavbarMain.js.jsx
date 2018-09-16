class mobileNavbarMain extends React.Component {
    render() {
        return (
            <div>
                <nav className="navbar navbar-expand-lg navbar-top">
                    <button id="sidenav-toggle" className="navbar-toggler navbar-toggler-left" type="button"
                            data-toggle="collapse"
                            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span className="icon-paragraph-left3"></span>
                    </button>

                    <a className="navbar-brand" href="/">
                        <img src="/assets/logo/logo_new.png"/>
                    </a>

                    <a href="/" className="navbar-toggler navbar-toggler-right navbar-toggler-user">
                        <img src="/assets/logo/logo_new.png"/>
                    </a>
                </nav>
                <button id="navbar-close" className="btn btn-outline-secondary navbar-toggler-close"
                        style="display: none;"
                        type="button">
                    <i className="icon-cross2"></i>
                </button>

                <nav id="nav" className="sidenav" data-sidenav data-sidenav-toggle="#sidenav-toggle">
                    <div className="sidenav-brand sidenav-brand-login">
                        <a href="/">
                            <img src="/assets/logo/logo_new.png"/>
                        </a>

                        <p className="mb-0 text-center">
                            Gustang
                        </p>
                    </div>

                    <ul className="sidenav-menu">
                        <li>
                            <a href="" className="">
        <span className="sidenav-link-title">
          <h4 className="mb-0 text-success">Rp 10.000.000</h4>
          <span className="text-muted">Saldo Abupay</span>
        </span>
                            </a>
                        </li>

                        <li>
                            <a href="" className="">
        <span className="sidenav-link-icon">
          <i className="icon-cash4"></i>
        </span>
                                <span className="sidenav-link-title">
          Bonus Fee

          <span className="float-right">Rp 100.000</span>
        </span>
                            </a>
                        </li>

                        <li>
                            <a href="" className="">
        <span className="sidenav-link-icon">
          <i className="icon-medal2"></i>
        </span>
                                <span className="sidenav-link-title">
          Poin

            <span className="float-right">100</span>
        </span>
                            </a>
                        </li>
                    </ul>

                    <div className="sidenav-header p-0"></div>

                    <ul className="sidenav-menu">
                        <li>
                            <a href="" className="">
        <span className="sidenav-link-icon">
          <i className="icon-bookmark3"></i>
        </span>
                                <span className="sidenav-link-title">Tentang Kami</span>
                            </a>
                        </li>

                        <li>
                            <a href="javascript:;" data-sidenav-dropdown-toggle className="">
        <span className="sidenav-link-icon">
          <i className="icon-bookmark3"></i>
        </span>
                                <span className="sidenav-link-title">Layanan</span>
                                <span className="sidenav-dropdown-icon show" data-sidenav-dropdown-icon>
            <i className="icon-arrow-down32"></i>
          </span>
                                <span className="sidenav-dropdown-icon" data-sidenav-dropdown-icon>
            <i className="icon-arrow-up32"></i>
          </span>
                            </a>

                            <ul className="sidenav-dropdown" data-sidenav-dropdown>
                                <li><a href="">Paket Umrah</a></li>
                                <li><a href="">Paket Haji</a></li>
                                <li><a href="">Cari Ustad</a></li>
                            </ul>
                        </li>

                        <li>
                            <a href="" className="">
        <span className="sidenav-link-icon">
          <i className="icon-bookmark3"></i>
        </span>
                                <span className="sidenav-link-title">Kemitraan</span>
                            </a>
                        </li>

                        <li>
                            <a href="" className="">
        <span className="sidenav-link-icon">
          <i className="icon-bookmark3"></i>
        </span>
                                <span className="sidenav-link-title">Blog</span>
                            </a>
                        </li>

                        <li>
                            <a href="" className="">
        <span className="sidenav-link-icon">
          <i className="icon-bookmark3"></i>
        </span>
                                <span className="sidenav-link-title">Bantuan</span>
                            </a>
                        </li>
                    </ul>

                    <div className="sidenav-header p-0"></div>

                    <ul className="sidenav-menu">
                        <li>
                            <a href="/">
                                <span className="sidenav-link-icon"><i className="icon-exit"></i></span>
                                <span className="sidenav-link-title">Keluar</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        )
    }
}