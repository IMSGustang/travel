class mobileNavigationFilters extends React.Component {
    render(){
        return(
            <div className="data-list-search">
                <nav className="navbar navbar-back-search navbar-light">
                    <a className="navbar-brand" href="/m/search-paket-umrah">
                        <i className="ion-ios-arrow-thin-left"></i>
                        <div className="data-search m-0">
                            <span className="data-city">Kota DKI Jakarta</span>
                            <span className="data-paket">
                                Reguler
                                <span className="text-muted mr-1 ml-1">|</span>
                                Maret
                                <span className="text-muted mr-1 ml-1">|</span>
                                2018
                            </span>
                        </div>
                    </a>
                </nav>

                <ul className="nav nav-pills nav-fill nav-filters">
                    <li className="nav-item">
                        <a className="nav-link" href="#" data-toggle="modal" data-target="#urutkan">
                            <i className="ion-android-options mr-2"></i> Urutkan
                        </a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" href="#" data-toggle="modal" data-target="#pencarian">
                            Ganti Pencarian <i className="ion-android-search ml-2"></i>
                        </a>
                    </li>
                </ul>
            </div>
        )
    }
}