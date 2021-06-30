namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      # spinner = TTY::Spinner.new("[:spinner] Apagando BD... ")
      # spinner.auto_spin 
      # %x(rails db:drop) 
      # spinner.success("Concluído com sucesso!")
      show_spinner("Apagando BD..."){ %x(rails db:drop) }
      show_spinner("Criando BD..."){ %x(rails db:create) }
      show_spinner("Migrando BD..."){ %x(rails db:migrate) }
      %x(rails dev:add_mining_types) 
      %x(rails dev:add_coins) 
      else
        puts "Você não está em ambiente de desenvolvimento!"
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins = [
          { 
              description: "Bitcoin",
              acronym: "BTC",
              url_image: "https://assets.cambiostore.com/assets/bitcoin-logo-11961d79a8fde725e878473bd3497adff1fb6d362c1378e9eb182c870a617a2a.png",
              mining_type: MiningType.first
          },
          { 
              description: "Ethereum",
              acronym: "ETH",
              url_image: "https://lh4.googleusercontent.com/njmacjXG5DhDcvSpCy6xd584sMRXIwoFxXliEZitBH4OqvK4IT_Zfi6DOuUQcsZNBeURhMtJoBhpLiiTqq6HL3yWmV9Kbpeq0LNbtxLANgAoYfk8rzJMsBYrzSKfTxyQp5Fw499f",
              mining_type: MiningType.all.sample
          },
          { 
              description: "Dash",
              acronym: "DASH",
              url_image: "https://assets.coingecko.com/coins/images/297/large/dashcoin.png?1547034071",
              mining_type: MiningType.all.sample
          }
      ]

  #esse find or create by verifica se ja existe ou nao se ja existir ele nao cadastra novamente o objeto no bd
    coins.each do |item|
      Coin.find_or_create_by!(item) 
    end
  end
end

desc "Cadastra os Tipos de mineração"
task add_mining_types: :environment do
  show_spinner("Cadastrando tipos de mineração...") do
    mining_types = [
      { description:"Proof of Work", acronym: "Pow"},
      { description:"Proof of Stake", acronym: "PoS"},
      { description:"Proof of Capacity", acronym: "PoC"}
    ]

    mining_types.each do |item|
      MiningType.find_or_create_by!(item) 
    end
  end
end

  private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin 
    yield
    spinner.success("(#{msg_end})")
  end

end
