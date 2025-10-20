# 🧪 Guia de Teste: Sincronização Desktop & Mobile

Este guia ajudará você a verificar que Desktop e Mobile estão **compartilhando todos os dados corretamente**.

## 📋 Pré-requisitos

1. Aplicação rodando no Replit
2. Credenciais de login:
   - **Email**: daviemericko@gmail.com  
   - **Senha**: 230723Davi#

## 🎯 Teste 1: Configurações de Integração (Supabase)

### Desktop → Mobile

1. **Desktop - Abrir Navegador em Modo Desktop** (>768px de largura)
   ```
   - Faça login
   - Clique no ícone de Configurações (⚙️) no header superior
   - Role até "Integrações"
   - Clique em "Supabase"
   ```

2. **Desktop - Configurar Supabase**
   ```
   - URL: https://teste-sync.supabase.co
   - Anon Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.exemplo
   - Bucket: receipts
   - Clique em "Salvar"
   - Aguarde confirmação ✅
   ```

3. **Mobile - Abrir Navegador em Modo Mobile** (<768px de largura)
   ```
   - Redimensione a janela para <768px OU use DevTools (F12) → Toggle Device Toolbar
   - Atualize a página (F5)
   - Clique no ícone de Configurações (⚙️) no header superior
   ```

4. **Mobile - Verificar Sincronização**
   ```
   ✅ ESPERADO: Supabase deve aparecer como "Conectado" com badge verde
   ✅ ESPERADO: Ao clicar em "Supabase", os mesmos dados aparecem:
      - URL: https://teste-sync.supabase.co
      - Anon Key: (mascarado)
      - Bucket: receipts
   ```

### Mobile → Desktop

5. **Mobile - Alterar Configuração**
   ```
   - Ainda no Mobile (largura <768px)
   - Clique em "Supabase"
   - Altere o Bucket para: "invoices"
   - Clique em "Salvar"
   - Aguarde confirmação ✅
   ```

6. **Desktop - Verificar Sincronização**
   ```
   - Volte para o modo Desktop (>768px)
   - Atualize a página (F5)
   - Abra Configurações → Supabase
   
   ✅ ESPERADO: Bucket deve estar como "invoices"
   ```

## 🎯 Teste 2: Perfil de Usuário

### Mobile → Desktop

1. **Mobile - Alterar Nome do Usuário**
   ```
   - Modo Mobile (<768px)
   - Configurações → Perfil
   - Altere o nome para: "Davi Emerick (Mobile Test)"
   - Salve
   ```

2. **Desktop - Verificar Sincronização**
   ```
   - Volte para Desktop (>768px)
   - Atualize a página (F5)
   
   ✅ ESPERADO: Nome deve ser "Davi Emerick (Mobile Test)"
   ```

## 🎯 Teste 3: Workspace (Pages)

### Desktop → Mobile

1. **Desktop - Criar Nova Página**
   ```
   - Modo Desktop
   - Vá para /workspace
   - Clique em "+ Nova Página"
   - Título: "Teste de Sincronização Desktop"
   - Adicione algum conteúdo
   - Salve (Ctrl+S)
   ```

2. **Mobile - Verificar Sincronização**
   ```
   - Volte para Mobile
   - Vá para /workspace
   
   ✅ ESPERADO: Página "Teste de Sincronização Desktop" deve aparecer na lista
   ```

### Mobile → Desktop

3. **Mobile - Criar Nova Página**
   ```
   - Modo Mobile
   - Vá para /workspace
   - Clique em "+ Nova Página"
   - Título: "Teste de Sincronização Mobile"
   - Adicione algum conteúdo
   - Salve
   ```

4. **Desktop - Verificar Sincronização**
   ```
   - Volte para Desktop
   - Atualize /workspace
   
   ✅ ESPERADO: Ambas as páginas devem aparecer:
      - "Teste de Sincronização Desktop"
      - "Teste de Sincronização Mobile"
   ```

## 🎯 Teste 4: Notificações

### Desktop → Mobile

1. **Desktop - Alterar Preferências**
   ```
   - Configurações → Notificações
   - Desative "Email"
   - Ative "WhatsApp"
   ```

2. **Mobile - Verificar**
   ```
   - Vá para Configurações → Notificações
   
   ✅ ESPERADO:
      - Email: Desativado
      - WhatsApp: Ativado
   ```

## 🎯 Teste 5: Tema (Dark/Light)

1. **Desktop - Mudar para Light**
   ```
   - Configurações → Aparência
   - Ative "Modo Claro"
   ```

2. **Mobile - Verificar**
   ```
   - Volte para Mobile
   - Atualize
   
   ✅ ESPERADO: Interface deve estar em modo claro
   ```

## 📊 Checklist de Resultados

Marque ✅ conforme testa:

- [ ] Teste 1: Supabase Desktop → Mobile
- [ ] Teste 1: Supabase Mobile → Desktop
- [ ] Teste 2: Perfil Mobile → Desktop
- [ ] Teste 3: Workspace Desktop → Mobile
- [ ] Teste 3: Workspace Mobile → Desktop
- [ ] Teste 4: Notificações Desktop → Mobile
- [ ] Teste 5: Tema Desktop → Mobile

## 🔍 Como Funciona a Sincronização

### React Query (Automático)
```javascript
// Configuração que garante sincronização
staleTime: 0,               // Sempre busca dados frescos
refetchOnMount: true,       // Atualiza ao montar componente
refetchOnWindowFocus: true, // Atualiza ao focar janela
```

Isso significa:
- ✅ Ao trocar de Desktop → Mobile: React Query busca dados atualizados
- ✅ Ao trocar de Mobile → Desktop: React Query busca dados atualizados
- ✅ Ao dar F5: Dados são recarregados do backend

### Zustand + Supabase (Workspace)
```javascript
// Sincronização em tempo real
1. Salva no localStorage (instantâneo)
2. Sincroniza com Supabase (background, 300ms debounce)
3. Ao abrir em outro dispositivo: carrega do Supabase
```

### localStorage (Compartilhado)
```javascript
// Mesmo domínio = mesmo localStorage
user-name
user-email
notification-settings
auth_token
```

## ❌ Problemas Comuns

### "Dados não aparecem no Mobile"
**Solução**: Atualize a página (F5). React Query pode estar usando cache.

### "Workspace não sincroniza"
**Solução**: Aguarde 1-2 segundos após salvar. Supabase sync é assíncrona.

### "Tema não muda"
**Solução**: Verifique se está usando o mesmo navegador (localStorage é por navegador).

## ✅ Conclusão

Se todos os testes passarem, significa que:

✅ Desktop e Mobile são **independentes no design**  
✅ Desktop e Mobile **compartilham todos os dados**  
✅ Sincronização é **automática e em tempo real**  
✅ Não há **duplicação ou isolamento de dados**

A arquitetura está funcionando **exatamente como planejado**! 🎉
