class mobileImagesDetail extends React.Component {
    render() {
        return (
            <div className="data-images-detail mb-3">
                <div className="card text-white">
                    <img className="card-img" src="/assets/lib/cover/1.gif" alt=""/>
                    <div className="card-img-overlay">
                        <h5 className="card-title">
                            Umrah Ownership Reguler Amanah Agustus 2018 12 Hari Quad
                        </h5>
                    </div>
                </div>

                <table className="table table-sm mb-0">
                    <tbody>
                    <tr>
                        <td>
                            <i className="ion-android-walk mr-2"></i>
                            <span>Maret 2018</span>
                        </td>
                        <td>
                            <i className="ion-android-pin mr-2"></i>
                            <span>Kantor Cabang Semarang</span>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <h4 className="mb-0">
                                Rp 30,000,000
                            </h4>
                        </td>
                        <td>
                            <a href="/m/approval-paket" className="btn btn-block btn-danger">Pesan Sekarang</a>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        )
    }
}