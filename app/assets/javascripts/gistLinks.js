$(document).on('turbolinks:load', function () {
    $('.link.link-gist').each(function(){
        var gist_id = $(this).data('id');
        $(this).replaceWith(`<a href="https://https://api.github.com/gists/${gist_id}.json"></a>`);
    })
});
