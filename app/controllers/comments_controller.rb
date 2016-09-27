class CommentsController < ApplicationController
  before_action :set_comment, except: [:new, :create, :index]
  before_action -> { require_user remote: true }
  before_action -> { require_logged_in_as @comment.board_members, remote: true },
    except: [:new, :create, :index]

  def index
    board = Board.find params[:board_id]
    return unless require_logged_in_as board.members, remote: true

    @comments = Comment.joins(card: [list: :board]).
                        where(lists: { board_id: board.id })
  end

  def show
  end

  def create
    @comment = Comment.new comment_params
    @comment.author = current_user
    return unless require_logged_in_as @comment.board_members, remote: true

    if @comment.save
      render template: 'comments/show', status: :created, location: @comment
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update comment_params
      render template: 'comments/show', status: :ok, location: @comment
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy
      head :no_content
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit :body, :card_id
  end

  def set_comment
    @comment = Comment.find params[:id]
  end
end
