class CommentsController < BaseController
  load_and_authorize_resource only: :destroy
<<<<<<< HEAD
  load_resource only: [:like, :translate]
  skip_before_filter :authenticate_user!, only: :translate
=======
  before_filter :get_comment, only: [:like, :translate]
>>>>>>> 60a49ac... Add Bing translation option to discussion comments

  def destroy
    CommentDeleter.new(@comment).delete_comment
    flash[:notice] = t(:"notice.comment_deleted")
    redirect_to discussion_url(@comment.discussion)
  end

  def like
    if params[:like] == 'true'
      DiscussionService.like_comment(current_user, @comment)
    else
      DiscussionService.unlike_comment(current_user, @comment)
    end

    render :template => "comments/comment_likes"
  end
  
  def translate
<<<<<<< HEAD
    @translation = @comment.translate @comment.author.primary_language, I18n.locale.to_s
=======
    @translation = @comment.translate @comment.author.primary_language, current_user.primary_language
>>>>>>> 60a49ac... Add Bing translation option to discussion comments
    @success = @translation.present? && @translation != @comment.body
    
    render :template => "comments/comment_translations"
  end
<<<<<<< HEAD

end
=======
  
  private
  
  def get_comment
    @comment = Comment.find(params[:id])
  end
  
end
>>>>>>> 60a49ac... Add Bing translation option to discussion comments
