class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Estudando o curso de Ruby On Rails![COOKIE]"
    session[:curso] = "Estudando o curso de Ruby On Rails![SESSIONS]"
    @meu_nome = params[:nome]
    @curso = params[:curso]
  end
end
