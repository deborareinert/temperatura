      $set sourceformat"free"
      *>Divisão de identificação do programa
       identification division.
       program-id. "lista11exercicio1v2".
       author. "Debora Reinert".
       installation. "PC".
       date-written. 16/07/2020.
       date-compiled. 16/07/2020.
      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.
      *>-----Declaração dos recursos externos
       input-output section.
       file-control.
                                   select arqTemp assign to "arqTemp.dat"
                                   organization is indexed
                                   access mode is dynamic
                                   lock mode is automatic
                                   record key is fd-dia
                                   file status is ws-fs-arqTemp.

       i-o-control.
      *>Declaração de variáveis
       data division.
      *>----Variaveis de arquivos
       file section.
       fd arqTemp.
       01 fd-temp.
           05 fd-dia                                pic  9(08).
           05 fd-temperatura                        pic  9(02)v9.

      *>----Variaveis de trabalho
       working-storage section.
       77 ws-menu                                   pic x(2).
       01 ws-temperaturas.
          05 ws-temperatura                                pic 9(02)v99.
          05 ws-dia                                 pic 9(08).
       01 ws-msn-erro.
          05 ws-msn-erro-ofsset                     pic 9(04).
          05 ws-msn-erro-cod                        pic 9(04).
          05 ws-msn-erro-text                       pic x(42).
       77 ws-sair                                   pic x(01).
          88  ws-sair-programa                      value "N" "n".
          88  ws-voltar                             value "V" "v".
       77  ws-fs-arqTemp                            pic 9(02).
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
           open i-o arqTemp
           if ws-fs-arqTemp  <> 00
           and ws-fs-arqTemp <> 05 then
               move 1                                   to ws-msn-erro-ofsset
               move ws-fs-arqTemp                       to ws-msn-erro-cod
               move "Erro ao abrir arquivo: (arqTemp) " to ws-msn-erro-text
               perform finaliza-anormal
           end-if
           .
       inicializa-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       processamento section.
           display erase
           perform until ws-sair-programa
               move space to ws-sair
               display "Escolha uma das opções abaixo: "
               display "'Ca' para cadastrar"
               display "'Ci' para consulta indexada"
               display "'Cs' para consulta sequencial"
               display "'De' para deletar"
               display "'Al' para alterar"
               accept ws-menu
               if ws-menu = "Ca" or "ca" then
                 perform cadastrar-temperatura
               else
                    if ws-menu = "Ci" or "ci" then
                      perform consultar-temperatura
                   else
                if ws-menu = "Cs" or "cs" then
                         perform seq
                        else
                             if ws-menu = "De" or "de" then
                                  perform deletar-temperatura
                             else
                                 if ws-menu = "Al" or "al" then
                                    perform alterar-temperatura
                                  else
                                   display "Opcao Inexistente"
               end-if
           end-perform
           .

       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Cadastro de temperatura
      *>------------------------------------------------------------------------
       cadastrar-temperatura section.
           display erase
           perform until ws-voltar or ws-sair-programa
               display "Digite a temperatura: "
               accept ws-temperatura
               display "Digite o dia: "
               accept  ws-dia
               write fd-temp from ws-temperaturas
               if ws-fs-arqTemp <> 0 then
                   move 2                                         to ws-msn-erro-ofsset
                   move ws-fs-arqTemp                             to ws-msn-erro-cod
                   move "Erro ao escrever arquivo: (arqTemp) "    to ws-msn-erro-text
                   perform finaliza-anormal
               end-if
               display "Deseja cadastrar mais um dia? Digite (S) para sim ou (V) para voltar"
               accept ws-sair
           end-perform
               .
       cadastrar-temperatura-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Consulta de temperatura sequencial usando next
      *>------------------------------------------------------------------------
       seq section.
           display erase
           perform consultar-temperatura
           perform until ws-voltar
               read arqTemp next
               if  ws-fs-arqTemp <> 0
               and ws-fs-arqTemp = 10 then
                      perform seq2
                  else
                      move 3                                         to ws-msn-erro-ofsset
                      move ws-fs-arqTemp                             to ws-msn-erro-cod
                      move "Erro ao ler arquivo: (arqTemp) "         to ws-msn-erro-text
                      perform finaliza-anormal
                  end-if
               move  fd-temp to  ws-temperaturas
               display "Digite a temperatura: "
               accept ws-temperatura
               display "Digite o dia: "
               accept  ws-dia
               display "Deseja consultar mais um dia? Digite (S) para sim ou (V) para voltar"
               accept ws-sair
           end-perform
           .
       seq-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Consulta de temperatura sequencial usando previous
      *>------------------------------------------------------------------------
       seq2 section.
           display erase
           perform until ws-voltar
               read arqTemp previous
               if  ws-fs-arqTemp <> 0  then
                  if ws-fs-arqTemp = 10 then
                      perform seq
                  else
                      move 4                                         to ws-msn-erro-ofsset
                      move ws-fs-arqTemp                             to ws-msn-erro-cod
                      move "Erro ao ler arquivo: (arqTemp) "         to ws-msn-erro-text
                      perform finaliza-anormal
                  end-if
               end-if
               move  fd-temp       to  ws-temperaturas
               display "Digite a temperatura: "
               accept ws-temperatura
               display "Digite o dia: "
               accept  ws-dia
               display "Deseja consultar mais um dia? Digite (S) para sim ou (V) para voltar"
           end-perform
           .
       seq2-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Consulta de temperatura indexada
      *>------------------------------------------------------------------------
       consultar-temperatura section.
               display erase
               display "Digite o dia que deseja consultar: "
               accept ws-dia
               move ws-dia to fd-dia
               read arqTemp

               if  ws-fs-arqTemp <> 0
               and ws-fs-arqTemp <> 10
               and ws-fs-arqTemp = 23 then
                       display "A data informada é inexistente"
                   else
                       move 5                                         to ws-msn-erro-ofsset
                       move ws-fs-arqTemp                             to ws-msn-erro-cod
                       move "Erro ao ler arquivo: (arqTemp) "         to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               move  fd-temp       to  ws-temperaturas
               display "A temperatura é: "  ws-temperatura
               display "O dia é: "  ws-dia
           .
       consultar-temperatura-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Alterar temperatura
      *>------------------------------------------------------------------------
       alterar-temperatura section.
               display erase
               perform consultar-temperatura
               display "Informe uma nova temperatura para alterar a antiga: "
               accept ws-temperatura
               move ws-temperatura to fd-temperatura
               rewrite fd-temp
               if  ws-fs-arqTemp = 0 then
                   display "A temperatura foi alterada"
               else
                   move 6                                         to ws-msn-erro-ofsset
                   move ws-fs-arqTemp                             to ws-msn-erro-cod
                   move "Erro ao alterar arquivo: (arqTemp) "     to ws-msn-erro-text
                   perform finaliza-anormal
               end-if
           .
       alterar-temp-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Deletar temperatura
      *>------------------------------------------------------------------------
       deletar-temperatura section.

               display erase
               display "Digite o dia que será excluido: "
               accept ws-dia
               move ws-dia to fd-dia
               delete arqTemp
               if  ws-fs-arqTemp = 0 then
                   display "A temperatura do dia digitado foi excluida"
               else
                   if ws-fs-arqTemp = 23 then
                       display "A data informada nao existe!"
                   else
                       move 7                                         to ws-msn-erro-ofsset
                       move ws-fs-arqTemp                             to ws-msn-erro-cod
                       move "Erro ao apagar arquivo: (arqTemp) "      to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if
           .
       deletar-temp-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Finalização
      *>------------------------------------------------------------------------
       finaliza section.
           display erase
           close arqTemp
           if ws-fs-arqTemp <> 0 then
               move 8                                to ws-msn-erro-ofsset
               move ws-fs-arqTemp                    to ws-msn-erro-cod
               move "Erro ao fechar arq. arqTemp "   to ws-msn-erro-text
               perform finaliza-anormal
           end-if
           Stop run
           .
       finaliza-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Finalização  Anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.
           display erase
           display ws-msn-erro-text.
           Stop run
           .
       finaliza-anormal-exit.
           exit.
