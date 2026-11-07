# Zsh-Config

Mi configuración de Zsh, sin oh-my-zsh: un `.zshrc` simple para personalizar a gusto y un `.zsh_aliases` con los alias. Forma parte de mis dotfiles de [BSPWM](https://github.com/Jimmy4TK/BSPWM), pero se puede usar sola.

![Zsh dentro de tmux](images/Tmux-Zsh.png)

## Incluye

- **Prompt minimalista:** la ruta actual alineada a la derecha y un `❯` que se pone verde o rojo según cómo terminó el último comando. A la derecha muestra la rama de git y si hay cambios (`✗`) o no (`✓`).
- **Historial limpio:** no guarda los comandos que fallan, aunque el último fallido sigue disponible con flecha arriba hasta que ejecutes otro para corregirlo. Tampoco guarda duplicados seguidos ni comandos triviales como `ls`, `cd` o `clear`. El historial se comparte entre terminales (10.000 entradas).
- **Completado** con menú navegable y sin distinguir mayúsculas de minúsculas. `Shift+Tab` recorre el menú hacia atrás.
- **Atajos:** estilo Emacs, `↑` / `↓` buscan en el historial los comandos que empiezan con lo que ya escribiste y `Ctrl+f` abre el sessionizer de [Tmux-Config](https://github.com/Jimmy4TK/Tmux-Config).
- **Plugins:** [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) y [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting).
- **Alias:** el repo no trae alias. Si existe `~/.zsh_aliases`, lo carga, así que ahí van los tuyos. [`.zsh_aliases.example`](.zsh_aliases.example) tiene un ejemplo para arrancar (`g`, `vim`, `ls` / `ll` con eza y `cat` con bat, cada uno solo si el programa está instalado).
- **Entornos:** carga [rvm](https://rvm.io), [nvm](https://github.com/nvm-sh/nvm) y [autoenv](https://github.com/hyperupcall/autoenv) si están instalados.

## Instalación

Requiere `zsh`, `git` y los dos plugins instalados en `/usr/share/zsh/plugins/`, que es donde los deja el gestor de paquetes en Arch (`sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting`). Para que el ícono de git del prompt se vea bien hace falta una Nerd Font.

```sh
mv ~/.zshrc ~/.zshrc.bak   # si ya tenés una config
git clone https://github.com/Jimmy4TK/Zsh-Config ~/.config/zsh-config
ln -sf ~/.config/zsh-config/.zshrc ~/.zshrc
cp -n ~/.config/zsh-config/.zsh_aliases.example ~/.zsh_aliases   # opcional
chsh -s "$(which zsh)"     # si zsh todavía no es tu shell
```

Con el enlace simbólico, un `git pull` en `~/.config/zsh-config` alcanza para actualizar.

## Integración con BSPWM

El `.zshrc` carga `~/.zsh_functions` si existe, antes que los alias. El instalador de [BSPWM](https://github.com/Jimmy4TK/BSPWM) deja ahí comandos como `pomodoro`, `target` o `eww`. Si no usás BSPWM, podés usar ese archivo para tus propias funciones.

## Licencia

[BSD 2-Clause](LICENSE).
