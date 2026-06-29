## Bugs Identificados

### 1 — App não consegue comunicar com o backend localmente: tráfego HTTP bloqueado

- **Tela:** Todas.
- **Passos para reproduzir:** Instalar o app e tentar logar.
- **Esperado:** Requisições HTTP a API localmente funcionarem.
- **Atual:** O `AndroidManifest.xml` não declara `android:usesCleartextTraffic="true"` nem `networkSecurityConfig`. Como a API é `http://`, o Android bloqueia todas as requisições (`Cleartext HTTP traffic not permitted`). A exceção é engolida pelo `try/catch` do login → falha silenciosa.

### 2 — Diário não salva nada

- **Telas:** Dor, Inchaço (`user_level_selection_with_options.dart:116`), Fadiga, Sono (`user_level_selection.dart:76`)
- **Passos para reproduzir:** Diário → Dor → marcar "Mãos" → escolher nível 8 → **Salvar**.
- **Esperado:** Salvar o registro.
- **Atual:** No `ConfirmationButtons`, o ramo `confirmed` é `: null`. Nada é salvo, nenhuma chamada de API, nenhum feedback; a tela apenas permanece. O valor coletado é descartado.

### 3 — Evolução exibe dados falsos (hardcoded), não os do usuário

- **Tela:** `evolution_page.dart:120-162`
- **Passos para reproduzir:** Abrir aba "Evolução".
- **Esperado:** Gráfico dos sintomas reais dos últimos 7 dias.
- **Atual:** As séries "Dor" e "Fadiga" são `FlSpot` **fixos no código** (`8,6,7,5,4,6,3` e `4,5,5,3,6,8,4`). O gráfico ignora qualquer dado do usuário. Os rótulos do eixo X (Seg–Dom) também são fixos.

### 4 — Configurações → "Alterar Email"/"Alterar Senha" levam a "Page Not Found"

- **Telas:** `logged_settings_page.dart:25,31`, `routes/settings.routes.dart`
- **Passos para reproduzir:** Diário → engrenagem → "Alterar Email".
- **Esperado:** Abrir tela de alterar e-mail.
- **Atual:** `SettingsRoutes.getGoRoutes()` **nunca é registrado** na árvore de rotas, e as constantes são caminhos relativos (`'configuration/change-email'`) passados a `context.go`. Resultado: **`GoException: no routes for location: configuration/change-email`**. Mesma falha em "Alterar Senha".

### 5 — Login não persiste entre execuções (precisa logar toda vez)

- **Arquivos:** `services/security_token_service.dart:9-11,29-36`, `views/app.dart:13`
- **Passos para reproduzir:** Logar → fechar o app → reabrir.
- **Esperado:** Continuar logado.
- **Atual:** `App` decide a rota inicial com `SecurityTokenService().userLoggedIn()`, mas `_initTokens()` é `async` disparado sem `await` no construtor (cache em memória vazio no momento da checagem). Além disso, `saveToken()` **nunca atualiza** `_accessToken`/`_refreshToken` em memória. Logo `userLoggedIn()` é sempre `false` na inicialização → o app **sempre** abre no login.

### 6 — Cabeçalho de autenticação nunca é enviado (interceptor quebrado e não conectado)

- **Arquivos:** `utils/interceptors/auth_interceptor.dart:14-16`
- **Detalhe:** `interceptRequest` faz `request.headers['Authorization'] = 'Bearer $accessToken'`, mas `getToken(...)` retorna um `Future` **não‑aguardado** → o header vira literalmente `Bearer Instance of 'Future<String?>'`. Nem o `AuthInterceptor` nem o `RefreshTokenPolicy` são instanciados/conectados a qualquer cliente HTTP (verificado por busca global). **Nenhuma requisição do app envia token.** Endpoints protegidos retornariam 401 (no teste, `/trainings` e `/exercises` são públicos, por isso funcionaram).

### 7 — Endpoints de submissão do diário não existem no backend + concatenação de URL quebrada

- **Arquivo:** `view_models/diary_view_model.dart:42-69`
- **Detalhe:** O app posta para `daily-sleep-report/`, `daily-fatigue-report/`, `daily-pain-report/`, `daily-swelling-report/`. O backend (`authentication/urls.py`) só expõe `daily-pain-reports/` (plural) e `training-reports/` — **não existem** endpoints de sono/fadiga/inchaço, e nem o de dor bate (singular × plural). Além disso a concatenação `'${apiUrl}$endpoint'` sem separador gera `.../apidaily-sleep-report/`.

### 8 — Botões mortos (sem ação)

- **Ocorrências confirmadas:**
  - Login → "ESQUECI MINHA SENHA": `onPressed: () {}` (`login_page.dart:82`).
  - Cadastro → "ENVIAR": `onPressed: () {}` (`sign_up_page.dart:75`); campo de e‑mail é `const InputText` sem `onValueChanged`.
  - `send_password.dart` → "ENVIAR" morto; seta de voltar não é botão.
  - Alterar Email / Alterar Senha → "Enviar" no-op (`change_email_page.dart:34`, `change_password.dart:60`).
  - Configurações → "Permissões": corpo `// Do something` (`logged_settings_page.dart:37`).
  - Diário inicial → "EXERCÍCIOS" tem `onPressed` vazio (`user_diary_initial_selection.dart:74`).
  - **Medicamentos → "Novo Medicamento" → "Salvar"** só faz `Navigator.pop` (TODO); confirmado em runtime: "TesteMed" **não** foi adicionado.

### 9 — Cadastro inviável + payload de data incompatível

- **Detalhe:** A tela de "Cadastro" na verdade é uma tela de "receber senha por e‑mail" (duplicata de `send_password.dart`), com botão morto, não há como criar conta pela UI.

### 10 — Login sem feedback de erro/carregamento (exceção engolida)

- **Arquivo:** `view_models/login.view_model.dart:35-37`
- **Detalhe:** Falhas de login só fazem `log(...)`; não há spinner nem mensagem. Com credenciais erradas/sem rede, o usuário não vê nada acontecer. Também não há validação de campos vazios (clicar em ENTRAR com os campos vazios dispara requisição e falha em silêncio).

### 11 — Relaxamento exibe conteúdo errado (exercícios de mão como "respiração")

- **Arquivos:** `relaxation/breathing_page.dart:51-62`, `guided_relaxation_page.dart`
- **Detalhe:** Quando nenhum treino casa com "respiração"/"relaxamento", o código cai em `trainings.first`. Rodando o app, "Técnicas de respiração" listou **exercícios de mão** ("Dobrar a mão com dedos esticados") com vídeos de mão. O player funciona, mas o conteúdo está incorreto.

---

## Potenciais Problemas

### 1 — Segurança: credenciais/tokens trafegam em HTTP puro

- **Categoria:** Segurança
- **Descrição:** `Environment.apiUrl` tem fallback `http://200.136.215.174/api` (IP fixo). Login/refresh enviam usuário, senha e JWT sem TLS.
- **Impacto:** Interceptação de credenciais e tokens em rede não confiável. Migrar para HTTPS.

### 2 — Ausência de testes automatizados

- **Categoria:** Manutenção / Qualidade
- **Descrição:** **0 testes**, apesar de `mockito` estar nas dev_dependencies. Nenhuma rede de segurança contra regressões.

### 3 — Duas camadas de serviço duplicadas e inconsistentes

- **Categoria:** Manutenção
- **Descrição:** `TrainingService` e `PhysicalExercisesService` fazem o mesmo (`/trainings`, `/exercises`), com diferenças (checagem de status, barra final). `TrainingService` é instanciado direto em telas (não injetável). Risco de divergência.

---

## Sugestões de Melhoria

### 1 — Centralizar e endurecer a camada HTTP

- **Categoria:** Arquitetura
- **Descrição:** Unificar `TrainingService`/`PhysicalExercisesService` em um cliente único com `InterceptedClient` (auth + refresh já existentes), checagem de `statusCode`, timeouts e tratamento de erro padronizado. Migrar `DiaryViewModel` (que usa `dart:io HttpClient` cru) para essa camada.
- **Benefício:** Auth consistente, menos duplicação, erros tratáveis.

### 2 — Migrar para HTTPS e remover IP/segredos hardcoded

- **Categoria:** Segurança
- **Descrição:** Servir a API por HTTPS, remover o fallback `http://200.136.215.174/api`, e configurar `network_security_config` apenas para hosts de dev.
- **Benefício:** Proteção de credenciais/tokens.

### 3 — Introduzir testes automatizados

- **Categoria:** Testes
- **Descrição:** Criar `test/` com testes de unidade (view models, parsers de modelos, `ExerciseDifficulty`) e de widget.
- **Benefício:** Previne regressões nas implementações.

### 4 — Liberar recursos de mídia e reduzir duplicação de UI

- **Categoria:** Performance / Código
- **Descrição:** Mover controllers do YouTube para `StatefulWidget` com `dispose`; extrair botões repetidos (9 botões idênticos em `info_page.dart`, `CustomSolidButton`/`CustomOutlinedButton`) e páginas de conteúdo para o `InfoTemplatePage` existente.
- **Benefício:** Sem leaks, menos código.
