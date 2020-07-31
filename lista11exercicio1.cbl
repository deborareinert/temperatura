      $set sourceformat"free"

      *>Divisão de identificação do programa
       identification division.
       program-id. "lista11exercicio1".
       author. "Debora Reinert".
       installation. "PC".
       date-written. 15/07/2020.
       date-compiled. 15/07/2020.



      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----Declaração dos recursos externos
       input-output section.
       file-control.
       i-o-control.

      *>Declaração de variáveis
       data division.

      *>----Variaveis de arquivos
       file section.


      *>----Variaveis de trabalho
       working-storage section.
       01 ws-temperaturas occurs 30.
          05 ws-temp                               pic s9(02)v99.

       77 ws-media-temp                            pic s9(02)v99.
       77 ws-temp-total                            pic s9(03)v99.


       77 ws-dia                                   pic 9(02).
       77 ws-ind-temp                              pic 9(02).

       77 ws-sair                                  pic x(01).


      *>----Variaveis para comunicação entre programas
       linkage section.


      *>----Declaração de tela
       screen section.

      *>Declaração do corpo do programa
       procedure division.


           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  Procedimentos de inicialização
      *>------------------------------------------------------------------------
       inicializa section.
           move 12      to   ws-temp(1)
           move 23      to   ws-temp(2)
           move 35      to   ws-temp(3)
           move 32      to   ws-temp(4)
           move 31      to   ws-temp(5)
           move 31      to   ws-temp(6)
           move 23      to   ws-temp(7)
           move 23      to   ws-temp(8)
           move 25      to   ws-temp(9)
           move 18      to   ws-temp(10)
           move 17      to   ws-temp(11)
           move 11      to   ws-temp(12)
           move 0       to   ws-temp(13)
           move 5       to   ws-temp(14)
           move 12      to   ws-temp(15)
           move 11      to   ws-temp(16)
           move 15      to   ws-temp(17)
           move 23      to   ws-temp(18)
           move 25      to   ws-temp(19)
           move 28      to   ws-temp(20)
           move 19      to   ws-temp(21)
           move 24      to   ws-temp(22)
           move 30      to   ws-temp(23)
           move 32      to   ws-temp(24)
           move 32      to   ws-temp(25)
           move 31      to   ws-temp(26)
           move 23      to   ws-temp(27)
           move 24      to   ws-temp(28)
           move 39      to   ws-temp(29)
           move 38      to   ws-temp(30)
           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       processamento section.

      *>   chamando rotina de calculo da média de temp.
           perform calc-media-temp

      *>    menu do sistema
           perform until ws-sair = "S"
                      or ws-sair = "s"
               display erase

               display "Digite o dia que deseja testar: "
               accept ws-dia

               if  ws-dia >= 1
               and ws-dia <= 30 then
                   if ws-temp(ws-dia) > ws-media-temp then
                       display "A temperatura do dia " ws-dia " esta acima da media"
                   else
                   if ws-temp(ws-dia) < ws-media-temp then
                           display "A temperatura do dia " ws-dia " esta abaixo da media"
                   else
                           display "A temperatura esta na media"
                   end-if
                   end-if
               else
                   display "O dia informado é invalido"
               end-if

               display "Digite (T) para testar outra temperatura"
               display "Ou digite (S) para sair"
               accept ws-sair
           end-perform
           .
       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Calculo da média de temperatura
      *>------------------------------------------------------------------------
       calc-media-temp section.

           move 0 to ws-temp-total
           perform varying ws-ind-temp from 1 by 1 until ws-ind-temp > 30
               compute ws-temp-total = ws-temp-total + ws-temp(ws-ind-temp)
           end-perform

           compute ws-media-temp = ws-temp-total/30

           .
       calc-media-temp-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Finalização
      *>------------------------------------------------------------------------
       finaliza section.
           Stop run
           .
       finaliza-exit.
           exit.













