# Administração

## Símbolos

- ### Seleção: 𝜎
- ### Projeção: 𝜋
- ### Normalização, order by: 𝜏 
- ### União: ⋃ ou ∪
- ### Interseção: ∩
- ### Diferença de Conjuntos: −
- ### Produto Cartesiano: ×
- ### Junção: ⋈
- ### Agregação: Γ
- ### Divisão: ÷
- ### Renomeação: 𝜌

```zsh-syntax-highlighting
systemctl start mariadb.service
```
# Informações sobre o mariadb
https://wiki.archlinux.org/title/MariaDB


para apagar tudo:
```bash
cd /var/lib/mysql
ls
rm -r *
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl start mysqld
systemctl start mysql.service
systemctl start mariadb
mysql
```
https://serverfault.com/questions/812719/mysql-mariadb-not-starting

Apos isso vai ser necessário criar os usuários e as senhas:
```bash
sudo mysql -u root -p
CREATE USER 'usuario'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON *.* TO 'usuario'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
```

<div style="
    display: flex;
    align-items: center;
    justify-content: center;">
    <img width="47%" src="https://user-images.githubusercontent.com/15125899/172028418-55712d9e-3864-4221-91e5-b377b7f32d1b.png"/>
    <img width="47%" src="https://user-images.githubusercontent.com/15125899/172028421-d2f27c62-92fe-40b4-8274-275ad42a0a3f.png"/>
    <img width="47%" src="https://user-images.githubusercontent.com/15125899/172028427-f37eb971-be3c-4921-8322-a57018879003.png"/>
    <img width="47%" src="https://c.tenor.com/ijFEgTs6FGoAAAAi/test-gadgets.gif"/>
</div>
