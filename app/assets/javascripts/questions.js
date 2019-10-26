$(document).on('turbolinks:load', function () {
    $('.questions').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });

    App.cable.subscriptions.create('QuestionsChannel', {
        connected: function () {
            return this.perform('follow');
        },
        received: function (data) {
            $('.questions').append(JST["templates/question"](data));
        }
    })
});
