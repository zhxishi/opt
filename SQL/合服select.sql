select
    zone,
    name,
    ip,
    port,
    webport,
    start_time
from
    tbl_zoneinfo_android_sgzj2 t1
WHERE
    PORT IN (
        SELECT
            PORT
        FROM
            (
                SELECT
                    PORT
                FROM
                    tbl_zoneinfo_android_sgzj2
                WHERE
                    zone BETWEEN '393'
                    AND '403'
            ) t3
    )
    and ip = '119.3.8.190' ##########查询合服区间
SELECT
    t.zone,
    t.ip,
    t.PORT,
    t.webport
FROM
    tbl_zoneinfo_android_sgzj2 t
    RIGHT JOIN (
        SELECT
            PORT,
            ip
        FROM
            tbl_zoneinfo_android_sgzj2
        WHERE
            zone BETWEEN 413
            AND 425
        GROUP BY
            PORT
    ) s ON t.PORT = s.PORT
    AND t.ip = s.ip #######查询主服
SELECT
    min(zone) "主服"
FROM
    (
        SELECT
            t.zone,
            t.ip,
            t.PORT
        FROM
            tbl_zoneinfo_android_sgzj2 t
            JOIN (
                SELECT
                    PORT,
                    webport,
                    ip
                FROM
                    tbl_zoneinfo_android_sgzj2
                WHERE
                    zone = 416
            ) s ON t.PORT = s.PORT
            AND t.webport = s.webport
            AND s.ip = t.ip
    ) d;

#######查询主服和从服及ip
SELECT
    DISTINCT (m.zone) 主区,
    n.czone 从区,
    n.PORT 端口,
    n.ip 服务器IP
FROM
    (
        SELECT
            min(h.zone) zone,
            h.PORT PORT,
            h.ip ip
        FROM
            (
                SELECT
                    t.zone,
                    t.ip,
                    t.PORT,
                    t.webport
                FROM
                    tbl_zoneinfo_android_sgzj2 t
                    RIGHT JOIN (
                        SELECT
                            PORT,
                            ip
                        FROM
                            tbl_zoneinfo_android_sgzj2
                        GROUP BY
                            PORT,
                            ip
                    ) s ON t.PORT = s.PORT
                    AND t.ip = s.ip
            ) h
        GROUP BY
            h.PORT,
            h.ip
        ORDER BY
            1
    ) m
    LEFT JOIN (
        SELECT
            k.zone czone,
            b.PORT PORT,
            k.ip ip
        FROM
            tbl_zoneinfo_android_sgzj2 k
            LEFT JOIN tbl_zoneinfo_android_sgzj2 b ON k.PORT = b.PORT
            AND k.ip = b.ip
    ) n ON m.PORT = n.PORT
    AND m.ip = n.ip;

#####也可以用一下sql
SELECT
    DISTINCT (m.zone) 主区,
    n.czone 从区,
    n.PORT 端口,
    n.ip 服务器ip
FROM
    (
        SELECT
            min(h.zone) zone,
            h.PORT PORT,
            h.ip ip
        FROM
            (
                SELECT
                    t.zone,
                    t.ip,
                    t.PORT,
                    t.webport
                FROM
                    tbl_zoneinfo_android_sgzj2 t
                    RIGHT JOIN (
                        SELECT
                            PORT,
                            ip
                        FROM
                            tbl_zoneinfo_android_sgzj2
                        GROUP BY
                            PORT,
                            ip
                    ) s ON t.PORT = s.PORT
                    AND t.ip = s.ip
            ) h
        GROUP BY
            h.PORT,
            h.ip
        ORDER BY
            1
    ) m,
    (
        SELECT
            k.zone czone,
            b.PORT PORT,
            k.ip ip
        FROM
            tbl_zoneinfo_android_sgzj2 k
            LEFT JOIN tbl_zoneinfo_android_sgzj2 b ON k.PORT = b.PORT
            AND k.ip = b.ip
    ) n
WHERE
    m.PORT = n.PORT
    AND m.ip = n.ip;