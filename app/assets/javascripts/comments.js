$(document).on('turbolinks:load', function () {
    $('.new-comment').on('ajax:success', function (e) {
        let resourceName = e.detail[0]['commentable_type'].toLowerCase(),
            resourceId = e.detail[0]['commentable_id'],
            resourceContent = e.detail[0]['body'];

        $('textarea').val('');
        $(`#${resourceName}_${resourceId} .comments`).append('<div class="comment"><p>'+
            resourceContent + '</p></div>');
    })
        .on('ajax:error', function (e) {
            let errors = e.detail[0];
            
            $.each(errors, function (index, value) {
                $('.comment-errors').append('<p>' + index + ' ' + value + '<p>');
            })
        });

    App.cable.subscriptions.create('CommentsChannel', {
        connected:function () {
            let question_id = gon.question_id;
            return this.perform('follow', { question_id: question_id });
        },
        received: function (data) {
            if (gon.user_id !== data.comment.user_id) {
                let resourceName = data.comment.commentable_type,
                    resourceId = data.comment.commentable_id,
                    newComment = JST['templates/comment']({comment: data.comment});

                if (resourceName === 'Question') {
                    $(`#question_${resourceId} .comments`).append(newComment);
                } else if (resourceName === 'Answer') {
                    $(`#answer_${resourceId} .comments`).append(newComment);
                }
            }
        }
    })
});
