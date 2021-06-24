# Devnology Cars Manager

<p align="center">
  <img src="https://raw.githubusercontent.com/felnanuke2/devnology-veiculos/master/screenshot-2021-06-23_21.07.52.887.png" width="250"/>
  <img src="https://raw.githubusercontent.com/felnanuke2/devnology-veiculos/master/screenshot-2021-06-23_21.08.21.36.png" width="250"/>
  <img src="https://raw.githubusercontent.com/felnanuke2/devnology-veiculos/master/screenshot-2021-06-23_21.08.34.82.png" width="250"/>
  <img src="https://raw.githubusercontent.com/felnanuke2/devnology-veiculos/master/screenshot-2021-06-23_21.08.44.674.png" width="250"/>
 
</p>

O intuito deste exercício é validar o máximo de conhecimento que você possui.

Antes de mais nada, crie um repositório no git e cole o conteúdo desse texto no readme.

Você precisará construir um sistema para uma agência de veículos, ele será composto por uma api e um frontend (Desktop ou Mobile).
# BackEnd
- Foi usado Firebase como back end para esse projeto.
# FrontEnd 
- Para o frontend esse app ultiliza Flutter que pode ser usado para multiplas plataformas.
- Nesse caso a Configuração foi feita apenas para Android.




# Desisões
Crie um arquivo readme falando um pouco sobre quais as decisões que você tomou para a resolução do exercício, e, caso não tenha feito algo, explique o motivo. Também informe os passos para fazer sua aplicação rodar, e caso tenha, o processo de deploy.

- Para adicionar um veículo foi foi consumida a api da Fipe http://fipeapi.appspot.com/ para consultar as marcas, os nomes dos veículos anos e o valor médio de venda.
- Com o App é possível  gerar relatório em PDF e compartilha-lo onde queira.
O PDF possui informações de total de gastos com aquisições, total com vendas, lucro, e comissão dos vendedores, lista com todos os veículos adquiridos no período determinado e lista de veículos vendidos no período determinado.
- É necessário que o usuário se autentique para poder ultilizar o app.
Cada usuário possui seu próprio documento no banco de dados com seus próprios veículos.
O usuári podera acessar seus dados de qualquer lugar bastando possuir uma conta.
- A tela de de detalhes do veículo possui opções de fazer um venda caso ainda não tenha sido efetuada e 
excluir um veículo do banco de dados.

# Requerimentos do Sistema

- Cadastrar a compra de um veículo, modelo, marca, ano de fabricação, placa, cor, chassi, data da compra e valor da compra.

- Registrar a venda de um veículo, com data da venda, valor da venda e comissão do vendedor (10% sobre o lucro da venda).

- Deverá ser possível listar todos os veículos, veículos disponíveis e histórico de veículos vendidos.

- Listar o valor total em compras e vendas, lucro/prejuízo do mês e o valor pago em comissões.

Caso queira criar mais funcionalidades fique à vontade, apenas se lembre de mencionar sobre elas no readme.

Qualquer dúvida entre em contato comigo pelo linkedin, estarei à disposição para esclarecer quaisquer dúvidas que surgirem.

Ao finalizar a prova basta enviar o link do repositório no linkedin.

# Executar o App
- Clone esse repositório.
- Abra seu cmd no diretório raiz do Projeto.


se for excutar o app em um dispositivo real
- Execute o comando: flutter build apk (isso pode levar algum tempo)
- Execute o comando: flutter install apk (isso irá instalar o app no seu dispositivo)


Caso você queira executar o app em um emulador.
- Execute o comando: flutter run

- Fim!!
