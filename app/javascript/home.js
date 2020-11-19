$(() => {
    $("input[name='query']").on('change keyup paste', e => {
        $.get("api/procedure/search", { name: $(e.target).val() })
        .done(data => {
            $('#results').empty();
            if (data.length == 0)
                $('#results').append("<p>Nothing was found</p>");
            var $ul = $('#results').append("<ul></ul>");
            for (i = 0; i < data.length; i++)
                $ul.append("<li>"+data[i]['name']+"</li>");
        })
        .fail(() => console.log("Something went wrong"))
    });

    $(".sync-procedures").on('click', e => {
        $(e.target).html('Loading and Saving ...')
                   .attr("disabled", true);
        $.post("api/procedure", {})
        .done(() => 
            $(e.target).html('Load Procedures from Source')
                       .attr("disabled", false)
        )
        .fail(errors => console.log(errors))
    });
});