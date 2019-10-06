$(document).on('turbolinks:load', function () {
    $('.link-gist').each(function () {
        let gist_id = $(this).data('id'),
            gist_url = `https://api.github.com/gists/${gist_id}`,
            that = this;
            // gist_script = `https://gist.github.com/${gist_id}.js`,
            // script = jQuery.getScript(gist_script),

        // $(this).replaceWith(postscribe($(this), script));

        // $.getJSON(gist_url, (data =>
        //     Object.keys(data.files).forEach(item =>
        //     $(that).replaceWith(data.files[item].content))));

        fetch(gist_url)
            .then(response => {
                if (response.status >= 400) {
                    return Promise.reject('Не удалось загрузить gist');
                }

                response.json().then(function (data) {
                    Object.keys(data.files).forEach(item =>
                        $(that).replaceWith(data.files[item].content));
                });
            });
    });
});
