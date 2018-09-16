class mobileDataApproval extends React.Component {
    render() {
        return (
            <div className="data-approval">
                <ul className="nav nav-pills nav-fill nav-tabs" id="myTab" role="tablist">
                    <li className="nav-item">
                        <a className="nav-link active" id="syarat-tab" data-toggle="tab" href="#syarat" role="tab"
                           aria-controls="syarat" aria-selected="true">Syarat & Ketentuan</a>
                    </li>

                    <li className="nav-item">
                        <a className="nav-link" id="informasi-tab" data-toggle="tab" href="#informasi" role="tab"
                           aria-controls="informasi" aria-selected="false">Informasi Visa</a>
                    </li>
                </ul>

                <div className="tab-content">
                    <div className="tab-pane fade show active" id="syarat" role="tabpanel" aria-labelledby="syarat-tab">
                        <div className="card card-body">
                            <table className="table table-sm mb-0">
                                <tbody>
                                <tr>
                                    <td width={5}>1.</td>
                                    <td>
                                        Lorem ipsum dolor sit amet, consectetur adipisicing elit. Accusamus adipisci
                                        consectetur cum distinctio doloremque eveniet facilis ipsam iusto laboriosam
                                        molestiae nobis nulla officiis, quidem reprehenderit rerum soluta totam
                                        voluptates voluptatibus?
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div className="tab-pane fade" id="informasi" role="tabpanel" aria-labelledby="informasi-tab">
                        <div className="card card-body">
                            <table className="table table-sm mb-0">
                                <tbody>
                                <tr>
                                    <td width={5}>1.</td>
                                    <td>
                                        Lorem ipsum dolor sit amet, consectetur adipisicing elit. Accusamus adipisci
                                        consectetur cum distinctio doloremque eveniet facilis ipsam iusto laboriosam
                                        molestiae nobis nulla officiis, quidem reprehenderit rerum soluta totam
                                        voluptates voluptatibus?
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}