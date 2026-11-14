# brunomorenodev.com.br

Site de portfólio de Bruno Moreno: sistemas sob medida e automação.

## Estrutura

```
index.html            site público (projetos abrem em painel lateral, ex.: /#gestao-de-frota)
admin.html            painel para cadastrar e editar projetos
assets/config.js      WhatsApp, Instagram e chaves do Supabase
assets/favicon.svg    ícone da aba
data/projects.json    projetos iniciais (usados enquanto o Supabase não estiver configurado)
img/                  imagens dos projetos iniciais
supabase/schema.sql   tabelas, permissões e bucket de imagens
```

## 1. Ajustes rápidos

Em `assets/config.js`, troque `WHATSAPP` pelo seu número (DDI + DDD + número, só dígitos, ex.: `5511987654321`).
Quando tiver uma foto sua, adicione `PORTRAIT_URL: "img/bruno.jpg"` e coloque a foto nessa pasta.

## 2. Publicar no Vercel

1. Crie um repositório no GitHub (ex.: `1brunomoreno/portfolio`) e envie esta pasta.
2. No Vercel: Add New › Project › importe o repositório. Framework: **Other**. Não precisa de build.
3. Deploy. O site já funciona com os projetos de `data/projects.json`.

## 3. Ligar o domínio brunomorenodev.com.br

1. No Vercel: projeto › Settings › Domains › adicione `brunomorenodev.com.br` e `www.brunomorenodev.com.br`.
2. O Vercel mostra os registros DNS a criar (normalmente um **A** para o domínio e um **CNAME** para o `www`).
3. No Registro.br: Painel › clique no domínio › **DNS** › "Editar zona" e crie exatamente os registros que o Vercel mostrou.
4. Aguarde a propagação (de minutos a algumas horas). O HTTPS é gerado automaticamente.

## 4. Métricas do Vercel (visitas, origem, aparelho)

No projeto do Vercel: aba **Analytics** › **Enable**. O site já tem o script; depois do próximo deploy os dados começam a aparecer. Plano gratuito: 50 mil eventos por mês e histórico de 1 mês.

## 5. Ativar o painel (Supabase)

> O plano gratuito do Supabase permite 2 projetos ativos por organização. Se você já usa os dois, crie uma **nova organização** (ex.: "brunomorenodev") e crie o projeto do portfólio nela.

1. Crie um projeto no Supabase (região São Paulo).
2. SQL Editor › cole e rode `supabase/schema.sql` e depois `supabase/metricas.sql`.
3. Authentication › Users › **Add user** com seu e-mail e senha.
4. Rode no SQL Editor (trocando o e-mail):
   `insert into public.admins (user_id) select id from auth.users where email = 'SEU-EMAIL';`
5. Authentication › Providers › Email: **desative "Allow new users to sign up"**, para ninguém mais criar conta.
6. Project Settings › API: copie a URL e a chave `anon public` para `assets/config.js` e publique de novo.
7. Acesse `brunomorenodev.com.br/admin.html`, entre e clique em **Importar projetos iniciais**.

A partir daí, novos projetos são cadastrados só pelo painel, sem mexer no código, e a aba **Métricas** mostra visitas, cliques no WhatsApp, conversão, origem, aparelho e projetos mais abertos.

Dica: no link da bio do Instagram use `https://brunomorenodev.com.br/?utm_source=instagram` para as visitas vindas da bio aparecerem com a origem certa.

Se o projeto gratuito do Supabase ficar 7 dias sem nenhum acesso, ele é pausado. O site continua funcionando com os projetos de `data/projects.json`; é só reativar o projeto no painel do Supabase.
