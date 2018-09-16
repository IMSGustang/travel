class mobileCodeVoucher extends React.Component {
    componentDidMount() {
        $(document).ready(function () {
            var max = 3;
            var cnt = 1;
            $(".add-textbox").on("click", function (e) {
                e.preventDefault();
                if (cnt < max) {
                    cnt++;
                    $(".textbox-wrapper").append('' +
                        '<div class="input-group mb-2">' +
                        '<input type="text" name="text_arr[]" class="form-control" placeholder="Masukkan kode voucher" />' +
                        '<span class="input-group-btn">' +
                        '<button type="button" class="btn btn-danger remove-textbox">' +
                        '<i class="ion-minus"></i>' +
                        '</button>' +
                        '</span>' +
                        '</div>');
                }
            });

            $(".textbox-wrapper").on("click", ".remove-textbox", function (e) {
                e.preventDefault();
                $(this).parents(".input-group").remove();
                cnt--;
            });
        });
    }

    render() {
        return (
            <div className="data-code-voucher">
                <div className="card">
                    <div className="card-header">
                        <h5 className="mb-0">
                            Anda Memiliki Voucher ?
                        </h5>
                        <hr/>
                    </div>

                    <div className="card-body pt-0">
                        <div className="textbox-wrapper">
                            <div className="input-group mb-2">
                                <input type="text" name="text_arr[]" className="form-control" placeholder="Masukkan kode voucher" />
                                <span className="input-group-btn">
                                    <button type="button" className="btn btn-success add-textbox">
                                        <i className="ion-plus"></i>
                                    </button>
                                </span>
                            </div>
                        </div>

                        <button type="submit" className="btn btn-block btn-outline-danger mt-3">Konfirmasi Voucher</button>
                    </div>
                </div>
            </div>
        )
    }
}