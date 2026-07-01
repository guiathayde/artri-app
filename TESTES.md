# Índice do Vídeo de Teste — [TEST_SESSION](https://drive.google.com/file/d/1FTKxi9Mj6AkSvTklEWvcOGbjtO0BF1ed/view?usp=sharing)

Link do vídeo: https://drive.google.com/file/d/1FTKxi9Mj6AkSvTklEWvcOGbjtO0BF1ed/view?usp=sharing

## Índice por Fase

| Timecode | Fase | O que está sendo testado |
|----------|------|---------------------------|
| `00:00` | **Autenticação** | Tela de Login, link "Esqueci minha senha", tela de Cadastro e envio do formulário de cadastro. |
| `06:00` | **Diário (Home)** | Tela inicial "Como você está hoje?"; card de mito ("Fazer exercício irá piorar a dor") com botões ✓/✗ e "Saber mais". |
| `07:30` | **Registro de sintomas** | Diálogos de **Fadiga** (com tooltip "?"), **Sono** e **Inchaço**. Tooltips "?" só respondem a toque-longo, não a toque simples. |
| `12:00` | **Inchaço (scroll)** | Rolagem do conteúdo do diálogo/registro de inchaço. |
| `14:00` | **Exercícios — "Qual devo escolher?"** | Diálogo de ajuda de nível com vídeo embutido e texto rolável. Título do vídeo escrito "INTRUÇÕES" (correto: "INSTRUÇÕES"). |
| `16:00` | **Rotina Mãos — Iniciante** | Sequência guiada de exercícios das mãos: passos 1 a 7, vídeos sendo reproduzidos, navegação FEITO/próximo. |
| `24:50` | **Tela "Parabéns!"** | Conclusão da rotina de mãos. Texto "execícios" (correto: "exercícios"). |
| `26:00` | **Fim de rotina / navegação** | Estado pós-conclusão e retorno (botão voltar). |
| `28:00` | **Informações sobre atividades físicas** | Tela informativa + páginas "Artrite" e "Tratamentos". |
| `32:00` | **Páginas de Informações (9 telas)** | Minha dor, Sono, Alimentação (com tooltip), Emocional, Exercícios físicos, Lazer, todas com scroll do conteúdo. Tooltips "?" só por toque-longo. |
| `39:00` | **Evolução** | Gráfico de evolução; chips Dor/Fadiga (ambos, só fadiga) e estado vazio. Gráfico exibe dados fixos/hardcoded, não dados reais do usuário. |
| `41:00` | **Relaxamento guiado (áudio)** | Aba Exercício → Relaxamento → relaxamento guiado; player de áudio tocando e progredindo (reproduz até o fim OK). |
| `44:00` | **Técnicas de respiração** | Lista e vídeo de "Respiração". Mostra exercícios das MÃOS em vez de conteúdo de respiração (fallback `breathing_page.dart:59` → `trainings.first`). |
| `48:00` | **Configurações** | Tela de Configurações; "Alterar Email" e "Alterar Senha". Ambos levam a **404** (rotas nunca registradas no router). Botão voltar na tela 404 leva a "/" 404 e **sai do app**. |
| `51:00` | **Relogin + Permissões** | Relançamento do app, novo login (sessão não persiste) e botão **"Permissões"**. Botão "Permissões" é morto (callback vazio). |
| `56:00` | **Medicamentos** | Checklist diário; marcar/desmarcar item (funciona nos dois sentidos OK); botão "+" → formulário "Novo Medicamento". Dados são mock (Metotrexato/Ácido Fólico/Prednisona). "Salvar" no formulário **não adiciona** o medicamento à lista. |
| `62:00` | **Voltar sai do app + relogin** | Botão voltar na tela Medicamentos **sai do app**; relançamento e novo login. |
| `64:00` | **Exercícios — Pés (seleção)** | Home → Exercícios físicos → Pés → níveis (Iniciante/Intermediário/Avançado), "Qual devo escolher?", lista de exercícios do Pés Iniciante com scroll. Botão "EXERCÍCIOS" da Home não navega (só a aba inferior "Exercício" funciona). |
| `68:00` | **Rotina Pés — Iniciante (vídeos até o fim)** | COMEÇAR → diálogo ATENÇÃO → player; **vídeos reproduzidos até a conclusão**; navegação FEITO/anterior/próximo por todos os exercícios; tela final "Parabéns!". |
