class mobilePaymentMethodDetailTransfer extends React.Component {
    render() {
        return (
            <div className="data-payment-method-detail-transfer">
                <div className="card">
                    <div className="card-header">
                        <a href="/m/payment-method" className="btn btn-sm btn-block btn-outline-danger">
                            Ganti Metode Pembayaran
                        </a>
                    </div>

                    <div className="card-body">
                        <table className="table table-sm mb-0">
                            <tbody>
                            <tr>
                                <th>
                                    Bank Tujuan Transfer :
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    <label className="custom-control custom-radio">
                                        <input id="radio1" name="radio" type="radio" className="custom-control-input" defaultChecked />
                                            <span className="custom-control-indicator"></span>
                                            <span className="custom-control-description">
                                                Mandiri - 00000000000000
                                                <img src="/assets/lib/payment-icon/MANDIRI.png" />
                                            </span>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label className="custom-control custom-radio">
                                        <input id="radio1" name="radio" type="radio" className="custom-control-input" />
                                            <span className="custom-control-indicator"></span>
                                            <span className="custom-control-description">
                                                BRI - 00000000000000
                                                <img src="/assets/lib/payment-icon/BRI.png" />
                                            </span>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label className="custom-control custom-radio">
                                        <input id="radio1" name="radio" type="radio" className="custom-control-input" />
                                            <span className="custom-control-indicator"></span>
                                            <span className="custom-control-description">
                                                BCA - 00000000000000
                                                <img src="/assets/lib/payment-icon/BCA.png" />
                                            </span>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label className="custom-control custom-radio">
                                        <input id="radio1" name="radio" type="radio" className="custom-control-input" />
                                            <span className="custom-control-indicator"></span>
                                            <span className="custom-control-description">
                                                BNI - 00000000000000
                                                <img src="/assets/lib/payment-icon/BNI.png" />
                                            </span>
                                    </label>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        )
    }
}