class mobilePacketDetail extends React.Component {
    render() {
        return (
            <div className="data-paket-detail">
                <ul className="nav nav-pills nav-fill nav-tabs" id="myTab" role="tablist">
                    <li className="nav-item">
                        <a className="nav-link active" id="home-tab" data-toggle="tab" href="#syarat" role="tab"
                           aria-controls="home" aria-selected="true">Persyaratan Umum</a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" id="home-tab" data-toggle="tab" href="#fasilitas" role="tab"
                           aria-controls="home" aria-selected="false">Fasilitas</a>
                    </li>
                </ul>

                <div className="tab-content">
                    <div className="tab-pane fade show active" id="syarat" role="tabpanel"
                         aria-labelledby="syarat-tab">
                        <div id="accordion" role="tablist">
                            <div className="card">
                                <div className="card-header" role="tab" id="headingOne">
                                    <h5 className="data-title mb-0">
                                        <a className="accordion-collapse" data-toggle="collapse" href="#collapseOne"
                                           role="button"
                                           aria-expanded="true" aria-controls="collapseOne">
                                            Persiapan Berkas
                                        </a>
                                    </h5>
                                </div>

                                <div id="collapseOne" className="collapse show" role="tabpanel"
                                     aria-labelledby="headingOne" data-parent="#accordion">
                                    <div className="card-body">
                                        Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry
                                        richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard
                                        dolor brunch. Food truck quinoa nesciunt laborum eiusmod.
                                    </div>
                                </div>
                            </div>

                            <div className="card">
                                <div className="card-header" role="tab" id="headingTwo">
                                    <h5 className="data-title mb-0">
                                        <a className="accordion-collapse collapsed" data-toggle="collapse"
                                           href="#collapseTwo"
                                           role="button" aria-expanded="false" aria-controls="collapseTwo">
                                            Pendaftaran dan Pelunasan
                                        </a>
                                    </h5>
                                </div>
                                <div id="collapseTwo" className="collapse" role="tabpanel"
                                     aria-labelledby="headingTwo" data-parent="#accordion">
                                    <div className="card-body">
                                        Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry
                                        richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard
                                        dolor brunch. Food truck quinoa nesciunt laborum eiusmod.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="tab-pane fade" id="fasilitas" role="tabpanel" aria-labelledby="fasilitas-tab">
                        <div id="accordion" role="tablist">
                            <div className="card">
                                <div className="card-header" role="tab" id="headingOne">
                                    <h5 className="data-title mb-0">
                                        <a className="accordion-collapse" data-toggle="collapse" href="#maskapai"
                                           role="button"
                                           aria-expanded="true" aria-controls="collapseOne">
                                            Maskapai
                                        </a>
                                    </h5>
                                </div>

                                <div id="maskapai" className="collapse show" role="tabpanel"
                                     aria-labelledby="maskapai" data-parent="#accordion">
                                    <div className="card-body">
                                        Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry
                                        richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard
                                        dolor brunch. Food truck quinoa nesciunt laborum eiusmod.
                                    </div>
                                </div>
                            </div>

                            <div className="card">
                                <div className="card-header" role="tab" id="headingTwo">
                                    <h5 className="data-title mb-0">
                                        <a className="accordion-collapse collapsed" data-toggle="collapse" href="#hotel"
                                           role="button" aria-expanded="false" aria-controls="hotel">
                                            Hotel
                                        </a>
                                    </h5>
                                </div>
                                <div id="hotel" className="collapse" role="tabpanel"
                                     aria-labelledby="hotel" data-parent="#accordion">
                                    <div className="card-body">
                                        Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry
                                        richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard
                                        dolor brunch. Food truck quinoa nesciunt laborum eiusmod.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}