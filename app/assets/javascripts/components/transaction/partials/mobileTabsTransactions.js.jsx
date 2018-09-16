class mobileTabsTransactions extends React.Component {
    render() {
        return (
            <div className="tabs-transactions">
                <ul className="nav">
                    <li className="nav-item">
                        <a className="nav-link active" href="/pembayaran-umrah">
                            <div className="icons-sm icons-umrah m-auto"></div>
                            Umrah
                        </a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" href="/transaksi-haji">
                            <div className="icons-sm icons-haji m-auto"></div>
                            Haji
                        </a>
                    </li>
                    {/*<li className="nav-item">*/}
                        {/*<a className="nav-link disabled" href="#">*/}
                            {/*<div className="icons-sm icons-tiketpesawat m-auto"></div>*/}
                            {/*Tiket Pesawat*/}
                        {/*</a>*/}
                    {/*</li>*/}
                    {/*<li className="nav-item">*/}
                        {/*<a className="nav-link disabled" href="#">*/}
                            {/*<div className="icons-sm icons-hotel m-auto"></div>*/}
                            {/*Hotel*/}
                        {/*</a>*/}
                    {/*</li>*/}
                    <li className="nav-item">
                        <a className="nav-link " href="/transaksi-evoucher">
                            <div className="icons-sm icons-pulsa m-auto"></div>
                            E-Voucher
                        </a>
                    </li>
                </ul>
            </div>
        )
    }
}