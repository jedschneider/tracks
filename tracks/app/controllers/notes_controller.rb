class NotesController < ApplicationController

  def index
    @all_notes = @user.notes
    @page_title = "TRACKS::All notes"
    respond_to do |format|
      format.html
      format.xml { render :xml => @all_notes.to_xml( :except => :user_id )  }
    end
  end

  def show
    @note = check_user_return_note
    @page_title = "TRACKS::Note " + @note.id.to_s
  end

  # Add a new note to this project
  #
  def create
    note = @user.notes.build
    note.attributes = params["new_note"]

    if note.save
      render :partial => 'notes_summary', :object => note
    else
      render :text => ''
    end
  end

  def destroy
    note = check_user_return_note
    if note.destroy
      render :text => ''
    else
      notify :warning, "Couldn't delete note \"#{note.id.to_s}\""
      render :text => ''
    end
  end

  def update
    note = check_user_return_note
    note.attributes = params["note"]
      if note.save
        render :partial => 'notes', :object => note
      else
        notify :warning, "Couldn't update note \"#{note.id.to_s}\""
        render :text => ''
      end
  end

  protected

    def check_user_return_note
      note = Note.find_by_id( params['id'] )
      if @user == note.user
        return note
      else
        render :text => ''
      end
    end
end