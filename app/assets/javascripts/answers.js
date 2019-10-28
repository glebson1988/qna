$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    App.cable.subscriptions.create('AnswersChannel', {
        connected: function () {
            let question_id = gon.question_id;
            return this.perform('follow', {question_id: question_id});
        },
        received: function (data) {
            if (gon.user_id !== data.answer.user_id) {
                console.log(data);
                $('.answers').append(JST['templates/answer']({
                    answer: data.answer,
                    links: data.links,
                    rating: data.rating
                }));
            }
        }
    })
});
