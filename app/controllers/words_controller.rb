class WordsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    @words = Word.all.page(params[:page])
  end

  # GET /words/1
  # GET /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(word_params)
    @word.word = @word.word.split(" ")[0].upcase
    included = validate_new_word
    if !included
      respond_to do |format|
        if @word.save
          format.html { redirect_to new_word_path, notice: 'Word was successfully created.' }
          format.json { render :show, status: :created, location: @word }
        else
          format.html { render :new }
          format.json { render json: @word.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to new_word_path, notice: 'This word already exists.'
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:word)
    end
    
    def validate_new_word
      included = Word.where(word: @word.word).exists?
      puts "\n\n\n+++++ #{@word.word} = #{included} ++++\n\n"
      included
    end
end
