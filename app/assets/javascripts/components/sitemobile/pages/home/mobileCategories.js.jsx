class mobileCategories extends React.Component {
    render() {
        return (
            <div className="data-kategori">
                <div className="card">
                    <h6 className="text-center card-title mt-4 mb-0">
                        Travel & E-voucher
                    </h6>
                    <div className="card-body mb-3">
                        <table className="table">
                            <tbody>
                            <tr>
                                <td>
                                    <a href="/umrah">
                                        <span className="badge">
                                            <div className="icons-sm icons-umrah mauto mt8"></div>
                                        </span>
                                        <p className="mb-0">Paket Umrah</p>
                                    </a>
                                </td>
                                <td>
                                    <a href="/haji">
                                        <span className="badge">
                                            <div className="icons-sm icons-haji mauto mt8"></div>
                                        </span>
                                        <p className="mb-0">Paket Haji</p>
                                    </a>
                                </td>
                                <td>
                                    <a href="/beli-pulsa">
                                        <span className="badge">
                                            <div className="icons-sm icons-pulsa mauto mt8"></div>
                                        </span>
                                        <p className="mb-0">Beli Pulsa</p>
                                    </a>
                                </td>
                                {/*<td>*/}
                                    {/*<a href="/flight">*/}
                                        {/*<span className="badge">*/}
                                            {/*<div className="icons-sm icons-tiketpesawat mauto mt8"></div>*/}
                                        {/*</span>*/}
                                        {/*<p className="mb-0">Tiket Pesawat</p>*/}
                                    {/*</a>*/}
                                {/*</td>*/}
                                {/*<td>*/}
                                    {/*<a href="#" className="disabled">*/}
                                        {/*<span className="badge">*/}
                                            {/*<div className="icons-sm icons-hotel mauto mt8"></div>*/}
                                        {/*</span>*/}
                                        {/*<p className="mb-0">Hotel</p>*/}
                                    {/*</a>*/}
                                {/*</td>*/}
                            </tr>

                            <tr>
                                <td>
                                    <a href="beli-paketdata">
                                        <span className="badge">
                                            <div className="icons-sm icons-paketdata mauto mt8"></div>
                                        </span>
                                        <p className="mb-0">Paket Internet</p>
                                    </a>
                                </td>

                                <td>
                                    <a href="beli-tokenlistrik">
                                        <span className="badge">
                                            <div className="icons-sm icons-tokenlistrik mauto mt8"></div>
                                        </span>
                                        <p className="mb-0">Token Listrik</p>
                                    </a>
                                </td>
                                <td>
                                    <a href="beli-vouchergame">
                                        <span className="badge">
                                            <div className="icons-sm icons-vouchergame mauto mt8"></div>
                                        </span>
                                        <p className="mb-0">Voucher Game</p>
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