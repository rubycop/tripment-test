$(function() {
    $("input[name='query']").on('change', function(e){
        $.get("api/procedure/search", { name: $(e.target).val() })
        .done(function (data) {
            $('#results').empty();
            if (data.length == 0) {
                $('#results').append("<p>Nothing was found</p>");
            }
            var $ul = $('#results').append("<ul></ul>");
            for (i = 0; i < data.length; i++) {
                $ul.append("<li>"+data[i]['name']+"</li>")
            }
        })
        .fail(function () {
            console.log("Something went wrong");
        })
    });


  });