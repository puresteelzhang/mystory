class RecommendController < ApplicationController
  include Recommend
  def blog
    _r = Rblog.find_by_user_id_and_blog_id(session[:id], params[:id])
    blog = Blog.find(params[:id])
    if _r.nil?
      rblog = save_rblog(blog)
    else
      _r.destroy
      Blog.update_all("recommend_count = #{blog.recommend_count - 1}", "id = #{blog.id}")
    end
    if blog.user.id == session[:id]
      expire_fragment("side_user_rblogs_#{session[:id]}")
      expire_fragment("side_blog_rblogs_#{session[:id]}")
    end
    render json: rblog.as_json
  end

  def note
    _r = Rnote.find_by_user_id_and_note_id(session[:id], params[:id])
    note = Note.find(params[:id])
    if _r.nil?
      rnote = Rnote.new
      rnote.user_id = session[:id]
      rnote.note = note
      rnote.save
      Note.update_all("recommend_count = #{note.recommend_count + 1}", "id = #{note.id}")
    else
      _r.destroy
      Note.update_all("recommend_count = #{note.recommend_count - 1}", "id = #{note.id}")
    end
    if note.user.id == session[:id]
      expire_fragment("side_note_rnotes_#{session[:id]}")
    end
    render json: rnote.as_json
  end

  def photo
    _r = Rphoto.find_by_user_id_and_photo_id(session[:id], params[:id])
    if _r.nil?
      rphoto = Rphoto.new
      rphoto.user_id = session[:id]
      rphoto.photo_id = params[:id]
      rphoto.save
    else
      _r.destroy
    end
    render json: rphoto.as_json
  end

  def memoir
    _r = Rmemoir.find_by_user_id_and_memoir_id(session[:id], params[:id])
    if _r.nil?
      rmemoir = Rmemoir.new
      rmemoir.user_id = session[:id]
      rmemoir.memoir_id = params[:id]
      rmemoir.save
    else
      _r.destroy
    end
    render json: rmemoir.as_json
  end

  def modify_blog
    @rblog = Rblog.find(params[:id])
    head :ok if @rblog.update_attributes(params[:ri])
  end
  
  def modify_note
    @rnote = Rnote.find(params[:id])
    head :ok if @rnote.update_attributes(params[:ri])
  end

  def modify_photo
    @rphoto = Rphoto.find(params[:id])
    head :ok if @rphoto.update_attributes(params[:ri])
  end

  def modify_memoir
    @rmemoir = Rmemoir.find(params[:id])
    head :ok if @rmemoir.update_attributes(params[:ri])
  end

end
