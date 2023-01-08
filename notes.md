- Aprovisionar container registry
    - Escrever como output a forma de aceder ao registry
- Push image to container registry
    - Escrever forma de referenciar as imagens num ficheiro
- Aprovisionar infraestrutura
    - Usar -var-file=ficheiro com referencia às imagens




Aprendizagens:
- Image ID é diferente de region para region. Se usar um Image ID de us-east-1 não vai funcionar em us-east-2
- Heredoc string. Começa com << (ou <<- para indented blocks). Posso colocar o identifier que quiser, desde que não apareça no texto em si. Tem de aparecer no final para marcar o fim. Convencionalmente, começa com EO (end of). EOT, EOF.


Questões:
- Se der erro a criar um resource, elimina os resources que criou? Reverte todas as alterações que fez?
