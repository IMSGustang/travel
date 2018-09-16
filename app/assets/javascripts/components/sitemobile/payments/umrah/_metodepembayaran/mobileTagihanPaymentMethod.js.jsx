class mobileTagihanPaymentMethod extends React.Component {
    render() {
        return (
            <div className="data-tagihan-payment-method">
                <div className="card">
                    <div className="card-body">
                        <table className="table table-sm mb-0">
                            <tbody>
                            <tr>
                                <td>
                                    <small>Total Tagihan Anda</small>
                                    <h5 className="mb-0">
                                        Rp 30,000,000
                                    </h5>
                                </td>

                                <td width={120} className="text-right">
                                    <a className="card-link" data-toggle="collapse" href="#linkdetailtagihan" role="button" aria-expanded="false" aria-controls="linkdetailtagihan">
                                        Lihat Tagihan <i className="ion-ios-arrow-down"></i>
                                    </a>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div className="collapse" id="linkdetailtagihan">
                    <div className="card card-collapse">
                        <div className="card-body">
                            <table className="table table-sm mb-0">
                                <tbody>
                                <tr>
                                    <td>
                                        Subtotal
                                    </td>
                                    <td width={150}>
                                        Rp 30,000,000
                                    </td>
                                </tr>

                                <tr>
                                    <th>
                                        Tagihan
                                    </th>
                                    <th width={150}>
                                        Rp 30,000,000
                                    </th>
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