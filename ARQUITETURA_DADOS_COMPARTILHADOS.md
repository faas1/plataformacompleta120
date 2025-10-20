# Arquitetura de Dados Compartilhados - Desktop & Mobile

## 📋 Resumo Executivo

O sistema ExecutiveAI Pro implementa uma **arquitetura de separação visual com dados unificados**:

- ✅ **Desktop e Mobile são independentes no DESIGN/UI**
- ✅ **Desktop e Mobile compartilham TODOS OS DADOS**
- ✅ **Sincronização automática entre plataformas**

## 🏗️ Camadas da Arquitetura

### 1. Camada de Apresentação (SEPARADA)
```
Desktop: src/pages/* 
Mobile:  src/platforms/mobile/pages/*
```

Cada plataforma tem seu próprio design:
- Desktop: Layout amplo, mouse/keyboard, header horizontal
- Mobile: Layout compacto, touch-first, bottom navigation

### 2. Camada de Dados (COMPARTILHADA)

#### 2.1 Backend API (Único)
```typescript
// Endpoints compartilhados por Desktop e Mobile:
/api/config/supabase/credentials    // Credenciais Supabase
/credentials/google_calendar         // Credenciais Google Calendar
/api/config/pluggy                   // Credenciais Pluggy
/api/config/redis/credentials        // Credenciais Redis
/api/config/sentry/credentials       // Credenciais Sentry
/api/config/cloudflare/credentials   // Credenciais Cloudflare
/api/config/better-stack/credentials // Credenciais Better Stack
/api/config/cache/settings           // Configurações de Cache
/api/config/optimizer/settings       // Configurações de Otimização
/api/config/monitoring/settings      // Configurações de Monitoramento
```

#### 2.2 Gerenciamento de Credenciais
```
server/lib/credentialsManager.ts
├─ Encriptação AES-256-GCM
├─ Armazenamento: data/credentials.json
└─ Backup: PostgreSQL Database
```

#### 2.3 Estado Global (Zustand)
```typescript
// src/stores/notionStore.ts
// Compartilhado entre Desktop e Mobile
- Pages
- Databases
- Boards
- Labels
```

#### 2.4 Contextos Compartilhados
```typescript
AuthContext      // User, Client, Login/Logout
FiltersContext   // Filtros e ordenação
ThemeProvider    // Dark/Light mode
```

#### 2.5 Armazenamento Local
```
localStorage (compartilhado):
├─ user-name
├─ user-email
├─ notification-settings
├─ auth_token
└─ workspace-storage (Zustand persist)
```

## 🔄 Fluxo de Sincronização

### Cenário 1: Configurar Supabase no Desktop
```
1. Desktop → Abre página de configurações
2. Desktop → Preenche URL e Anon Key do Supabase
3. Desktop → Clica em "Salvar"
4. Desktop → POST /api/config/supabase
5. Backend → Salva em data/credentials.json (encriptado)
6. Backend → Salva em PostgreSQL (backup)
7. Mobile  → useQuery invalida cache automaticamente
8. Mobile  → Busca dados atualizados do backend
9. Mobile  → Mostra Supabase conectado ✅
```

### Cenário 2: Conectar Banco no Mobile
```
1. Mobile  → Abre página de configurações
2. Mobile  → Conecta banco Pluggy
3. Mobile  → Clica em "Conectar"
4. Mobile  → POST /api/config/pluggy
5. Backend → Salva credenciais encriptadas
6. Desktop → React Query detecta mudança
7. Desktop → Atualiza status automaticamente
8. Desktop → Mostra Pluggy conectado ✅
```

## 🎯 Garantias de Sincronização

### 1. React Query (TanStack Query)
```typescript
// Configuração automática de sincronização
staleTime: 0,               // Sempre busca dados frescos
refetchOnMount: true,       // Atualiza ao montar componente
refetchOnWindowFocus: true, // Atualiza ao focar janela
```

### 2. Workspace Storage
```typescript
// src/lib/workspaceStorage.ts
- Prioridade: localStorage (rápido)
- Sincronização: Supabase (background)
- Sem separação desktop/mobile
```

### 3. Credenciais Encriptadas
```typescript
// server/lib/credentialsManager.ts
- Encriptação: AES-256-GCM
- Storage: data/credentials.json
- Multi-tenant: Por clientId
```

## 📊 Tabela de Compatibilidade

| Funcionalidade | Desktop | Mobile | Sincronizado |
|----------------|---------|--------|--------------|
| Login/Logout | ✅ | ✅ | ✅ Automático |
| Perfil de Usuário | ✅ | ✅ | ✅ localStorage |
| Configurações Supabase | ✅ | ✅ | ✅ Backend API |
| Configurações Google Calendar | ✅ | ✅ | ✅ Backend API |
| Configurações Pluggy | ✅ | ✅ | ✅ Backend API |
| Configurações Redis | ✅ | ✅ | ✅ Backend API |
| Configurações Sentry | ✅ | ✅ | ✅ Backend API |
| Workspace (Pages/Boards) | ✅ | ✅ | ✅ Zustand + Supabase |
| Notificações | ✅ | ✅ | ✅ localStorage |
| Tema (Dark/Light) | ✅ | ✅ | ✅ next-themes |

## 🧪 Como Testar a Sincronização

### Teste 1: Configurações de Integração
```
1. Desktop → Configure Supabase com URL e Anon Key
2. Mobile  → Abra página de configurações
3. Verifique → Supabase aparece como "Conectado" ✅
```

### Teste 2: Perfil de Usuário
```
1. Mobile  → Altere nome do usuário
2. Desktop → Atualize a página
3. Verifique → Nome atualizado aparece ✅
```

### Teste 3: Workspace Data
```
1. Desktop → Crie uma nova página no Workspace
2. Mobile  → Abra o Workspace
3. Verifique → Nova página aparece na lista ✅
```

## 🔧 Arquivos Principais

### Backend
```
server/lib/credentialsManager.ts  → Gerenciamento de credenciais
server/routes/config.ts           → Endpoints de configuração
server/routes/credentials.ts      → Endpoints de credenciais
server/lib/dynamicSupabase.ts     → Cliente Supabase dinâmico
```

### Frontend Compartilhado
```
src/contexts/AuthContext.tsx     → Autenticação global
src/stores/notionStore.ts        → Estado do Workspace
src/lib/workspaceStorage.ts      → Sincronização Supabase
src/lib/queryClient.ts           → Configuração React Query
```

### Frontend Desktop
```
src/pages/SettingsPage.tsx       → UI Desktop
```

### Frontend Mobile
```
src/platforms/mobile/pages/SettingsPage.tsx → UI Mobile
```

## ✅ Checklist de Verificação

- [x] Backend usa endpoints únicos para Desktop e Mobile
- [x] Credenciais armazenadas de forma centralizada
- [x] React Query sincroniza cache automaticamente
- [x] localStorage compartilhado entre plataformas
- [x] Zustand Store compartilhado
- [x] AuthContext compartilhado
- [x] Workspace sincroniza com Supabase
- [x] Sem duplicação de dados
- [x] Sem isolamento entre plataformas

## 🎨 Conclusão

A arquitetura atual é **perfeita** para suas necessidades:

- ✅ **Design independente**: Cada plataforma tem sua própria UI
- ✅ **Dados unificados**: Todas as informações são compartilhadas
- ✅ **Sincronização automática**: React Query + Supabase + localStorage
- ✅ **Segurança**: Credenciais encriptadas AES-256-GCM
- ✅ **Performance**: Cache inteligente e sincronização em background

**Não há necessidade de criar nada adicional** - o sistema já funciona exatamente como você descreveu!
