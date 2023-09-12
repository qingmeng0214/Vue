$(document).ready(function () {
    $("#searchForm").submit(function (event) {
        event.preventDefault();
        var keyword = $("input[name='keyword']").val();

        $.post("/search", { keyword: keyword }, function (data) {
            $("#results").html(data);
        });
    });

    $(document).on("click", ".saveBtn", function () {
        var selectedData = "";
        $("input[name='resultCheckbox']:checked").each(function () {
            selectedData += $(this).val() + "\n";
        });

        if (selectedData) {
            $.post("/download", { data: selectedData }, function () {
                window.location.href = "/download";
            });
        }
    });
});
