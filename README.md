# Argo CD — Projeto de Estudo (Day‑1)

Este repositório é um **starter** minimalista para você praticar Argo CD seguindo a estrutura típica de “Day‑1”:
- **Instalar o Argo CD**
- **Autenticar**
- **Criar uma Application** que aponta para este repo
- **Sincronizar e validar** um app simples (Nginx)

> **Objetivo**: ver o Git como fonte de verdade e o Argo CD reconciliando o estado do cluster.

---

## 1) Pré‑requisitos
- Um cluster Kubernetes acessível via `kubectl` (minikube, kind, k3d, EKS, etc.).
- `kubectl` instalado e apontando para o cluster correto (`kubectl get nodes` deve funcionar).
- (Opcional, mas recomendado) `argocd` CLI.

## 2) Instalar o Argo CD (namespace `argocd`)
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Aguarde os pods ficarem **Ready**:
```bash
kubectl -n argocd get pods
```

Exponha a UI via port‑forward (local):
```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443
# UI: https://localhost:8080
```

Pegue a senha inicial do usuário **admin**:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
```

> Dica: após trocar a senha, você pode remover o secret `argocd-initial-admin-secret` com segurança.

Login via CLI (opcional):
```bash
argocd login localhost:8080 --username admin --password <SENHA> --insecure
```

## 3) Subir este repositório para o Git
Crie um repositório seu (ex.: GitHub) e **suba este diretório**.

Depois, **edite** `argocd/application.yaml` e substitua o valor de `repoURL` pelo **URL do seu repositório**.

## 4) Criar a Application do Argo CD (via kubectl)
Aplique o manifest da Application (após ajustar o `repoURL`):
```bash
kubectl apply -f argocd/application.yaml
```

Verifique a Application:
```bash
kubectl -n argocd get applications.argoproj.io
# ou
argocd app get hello-nginx
```

## 5) Validar o app exemplo
Verifique se o namespace e os objetos foram criados:
```bash
kubectl get ns
kubectl -n hello-nginx get all
```

Faça um port‑forward para testar o Nginx:
```bash
kubectl -n hello-nginx port-forward svc/web 8081:80
# Abra http://localhost:8081
```

## 6) Fluxo de GitOps
Edite, por exemplo, `manifests/deployment.yaml` (mude `replicas` de 1→2) e faça **commit + push**.
A UI/CLI do Argo CD deve detectar o diff e aplicar a mudança conforme sua *syncPolicy*.

---

## Estrutura do repo
```
.
├── argocd
│   └── application.yaml        # Define a Argo CD Application apontando para /manifests
└── manifests
    ├── namespace.yaml          # Namespace do app
    ├── deployment.yaml         # Deployment Nginx
    └── service.yaml            # Service ClusterIP
```

## Notas
- A `syncPolicy` está em modo **automated** (prune + selfHeal) e com `CreateNamespace=true` para facilitar o Day‑1.
- Ajuste os recursos conforme necessário para seu ambiente.
