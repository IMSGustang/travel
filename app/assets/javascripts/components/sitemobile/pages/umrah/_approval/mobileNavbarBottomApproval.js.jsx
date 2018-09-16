class mobileNavbarBottomApproval extends React.Component {
    render() {
        return (
            <div className="data-navbar-price  fixed-bottom">
                <nav className="navbar navbar-price navbar-light">
                    <span className="navbar-brand">
                        <table className="table table-sm mb-0">
                            <tbody>
                            <tr>
                                <td>
                                    <small>Harga</small>
                                    <h5 className="mb-0">
                                        Rp30,000,000
                                    </h5>
                                </td>
                                <td width={118}>
                                    <a href="/m/payment-data-buyer" className="btn btn-block btn-danger">Bayar</a>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </span>
                </nav>
            </div>
        )
    }
}