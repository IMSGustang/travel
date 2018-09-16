class mobilePaymentMethodDetail extends React.Component {
    render() {
        return (
            <div className="data-payment-method-detail">
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
                                <td>
                                    <p className="text-left mb-0">
                                        Deposit
                                    </p>
                                </td>
                                <td width={140} className="text-right">
                                    <small>Sisa saldo anda</small>
                                    <p className="text-info mb-0">
                                        Rp 130,000,000
                                    </p>
                                </td>
                            </tr>

                            <tr>
                                <th>
                                    <p className="text-left mb-0">
                                        Saldo Terpakai
                                    </p>
                                </th>
                                <th width={140}>
                                    <p className="mb-0 text-danger text-right">
                                        - Rp 30,000,000
                                    </p>
                                </th>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        )
    }
}