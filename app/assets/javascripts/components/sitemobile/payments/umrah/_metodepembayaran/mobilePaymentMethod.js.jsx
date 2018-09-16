class mobilePaymentMethod extends React.Component {
    render() {
        return (
            <div className="data-payment-method">
                <div className="card">
                    <div className="card-header">
                        <h5 className="mb-0">
                            Pilih Metode Pembayaran
                        </h5>
                    </div>

                    <div className="card-body">
                        <table className="table table-sm mb-0">
                            <tbody>
                            <tr>
                                <td>
                                    <a href="/m/payment-method-detail-deposit">
                                        <div className="media">
                                            <img src="/assets/mobile/icons/deposit.png" className="align-self-center mr-3" />
                                            <div className="media-body">
                                                <h5 className="mb-0">Deposit</h5>
                                                <p className="mb-0">Rp 100,000</p>
                                            </div>
                                            <div className="align-self-center">
                                                <i className="ion-ios-arrow-thin-right"></i>
                                            </div>
                                        </div>
                                    </a>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <a href="/m/payment-method-detail-transfer">
                                        <div className="media">
                                            <img src="/assets/mobile/icons/deposit.png" className="align-self-center mr-3" />
                                            <div className="media-body">
                                                <h5 className="mb-0">Bank Transfer</h5>
                                                <p className="mb-0">
                                                    Via Teller, ATM atau Mobile Banking
                                                </p>
                                            </div>
                                            <div className="align-self-center">
                                                <i className="ion-ios-arrow-thin-right"></i>
                                            </div>
                                        </div>
                                    </a>
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