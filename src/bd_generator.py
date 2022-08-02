"""

Этот скрипт генерирует данные, которыми будет заполняться база данных шахматных партий


"""


from random import *
from chess import *

FIDE_CATS = [str(i) for i in range(1, 26)]

def genNames(n: int) -> List[Tuple[str, str, str]]:
    snames = ["Смирнов", "Иванов", "Кузнецов", "Волобуев", "Медведев", "Волков", "Зайцев", "Зеликман", "Блинов", "Денисов",
              "Потапов", "Фомин", "Гусев", "Щукин", "Никонов", "Глазунов", "Петров", "Вист", "Лосев", "Никитин", "Курочкин", "Богданов"]
    fnames = ["Василий", "Владимир", "Иван", "Михаил", "Павел", "Петр", "Яков", "Марк", "Арсений", "Никита", "Семен", "Валерий",
              "Андрей", "Антон", "Алексей", "Самуил", "Борис", "Сергей", "Арсен", "Леонид", "Никон", "Александр", "Геннадий", "Николай"]
    patrs = ["Васильевич", "Владимирович", "Иванович", "Михайлович", "Павлович", "Петрович", "Аронович", "Семенович", "Валерьевич",
             "Андреевич", "Антонович", "Алексеевич", "Сергеевич", "Геннадьевич", "Николаевич", "Александрович"]

    return [(choice(snames), choice(fnames), choice(patrs)) for _ in range(n)]


def genIds(n: int, min: int, max: int) -> List[int]:
    res = []
    while len(res) < n:
        new = randint(min, max)
        if new not in res:
            res.append(new)

    return res


def genDate() -> str:
    return str(genYear(1900, 2020)) + '-' + str(randint(1, 12)) + '-' + str(randint(1, 28))


def genYear(min, max) -> int:
    return randint(min, max)


def genPlayers(n: int):
    names = genNames(n)
    ids = [1503014] + genIds(n-1, 1000000, 9500000)
    ys = [genYear(1940, 2005) for _ in range(n)]

    return [(str(ids[i]), names[i][0], names[i][1], names[i][2], str(ys[i])) for i in range(n)]


def genArbiters(n: int):
    names = genNames(n)
    qcs = [randint(0, 3) for _ in range(n)]

    return [(str(names[i][0]), str(names[i][1]), str(names[i][2]), str(qcs[i])) for i in range(n)]


def genCompetition(n: int, arbiters):
    fns = ["Кубок", "Приз", "Чемпионат", "Турнир", "Встреча"]
    sns = ["города Москва", "весенних каникул", "осенних каникул", "города Васюки", "станции Бологое"]

    names = [choice(fns) + ' ' + choice(sns) for _ in range(n)]
    dates = [genDate() for _ in range(n)]
    formats = [choice(["round-robin", "swiss"]) for _ in range(n)]
    times = [choice(['90+30', '60+30', '15+10', '10+0', '2+0']) for _ in range(n)]
    nrounds = [10 + randint(-2, 2) for _ in range(n)]

    return [(names[i], dates[i], formats[i], times[i], str(nrounds[i]), str(randint(0, 23)), str(choice(arbiters))) for i in range(n)]


def genRounds(n, id):
    return [(genDate(), str(i), str(id)) for i in range(n)]


def genTime(n):
    return [[str(i), str(randint(1, 30)), str(randint(0, 59)), str(randint(1, 30)), str(randint(0, 59))] for i in range(n)]


def genMoves(n, whiteWin):
    def _randMoves():
        b = Board()
        b.reset()

        n_moves = 35 + randint(-10, 10)
        result = ''

        for i in range(1, n_moves + 1):
            if b.legal_moves.count() == 0:
                break
            m = choice(list(b.legal_moves))
            result += str(i) + '. ' + str(m) + ' '
            b.push(m)

            if i == n_moves and whiteWin:
                break

            if b.legal_moves.count() == 0:
                break

            m = choice(list(b.legal_moves))
            result += str(m) + ' '
            b.push(m)

        return result, choice('ABCDE') + str(choice([i for i in range(10, 100)]))

    return [_randMoves() for _ in range(n)]


def createPlayers(n):
    ps = genPlayers(n)
    with open('players.txt', 'w') as f:
        f.writelines(['\t'.join(p) + '\n' for p in ps])

    return ps


def createArbs(n):
    ars = genArbiters(n)
    with open('arbs.txt', 'w') as f:
        f.writelines([str(p) + '\t' + '\t'.join(ars[p]) + '\n' for p in range(len(ars))])


def createComps(n, arbiters):
    cs = genCompetition(n, arbiters)
    with open('comps.txt', 'w') as f:
        f.writelines([str(c) + '\t' + '\t'.join(cs[c]) + '\n' for c in range(len(cs))])


def createTimes(n):
    times = genTime(n)
    with open('times.txt', 'w') as f:
        f.writelines(['\t'.join(times[p]) + '\n' for p in range(len(times))])


def createMoves(n):
    white = randint(0, n/2)
    with open('moves.txt', 'w') as f:
        w1 = genMoves(int(n/2), int(white/2))
        w2 = genMoves(int(n/2), int((n-white)/2))
        f.writelines([str(p) + '\t' + '\t'.join(w1[p]) + '\n' for p in range(len(w1))] +
                     [str(int(n/2) + p) + '\t' + '\t'.join(w2[p]) + '\n' for p in range(len(w2))])

def createRanks():
    ranks = ["GM", "IM", "FM", "CM", "WGM", "WIM", "WFM", ""]
    with open('ranks.txt', 'w') as f:
        f.writelines([str(p) + '\t' + ranks[p] + '\n' for p in range(8)])


def create_Qualifs():
    cats = ["A", "B", "C", "D"]
    with open('qualif_cats.txt', 'w') as f:
        f.writelines([str(p) + '\t' + cats[p] + '\n' for p in range(4)])


def create_Fides():
    cats = [""] + [str(i) for i in range(25)]
    with open('FIDE_cats.txt', 'w') as f:
        f.writelines([str(p) + '\t' + cats[p] + '\n' for p in range(25)])


def createRounds(ids):
    # ids -- кол-во турниров
    roundIdx = 0
    ns = [randint(8, 10) for i in range(ids)]
    rounds = []
    with open('rounds.txt', 'w') as f:
        for i in range(ids):
            for p in genRounds(ns[i], i):
                f.write(str(roundIdx) + '\t' + '\t'.join(p) + '\n')
                rounds.append((roundIdx, p[2]))
                roundIdx += 1

    return roundIdx + 1, rounds


def createParticipations(n, players_ids):
    parts = [[str(i), str(randint(1800, 2100)), str(choice(players_ids)[0]),
             str(randint(0, 99)), str(randint(0, 7))] for i in range(n)]
    with open('partic.txt', 'w') as f:
        f.writelines(['\t'.join(p) + '\n' for p in parts])

    res = dict()
    for t in parts:
        player, competition = t[2], t[3]
        if competition not in res.keys():
            res[competition] = []
        res[competition].append(player)
    return res


def createRefereeing(n):
    arbsId = [i for i in range(1500)]
    refs = [[str(i), str(randint(0, 99)), str(arbsId.pop(randint(0, len(arbsId) - 1)))] for i in range(n)]
    with open('refers.txt', 'w') as f:
        f.writelines(['\t'.join(p) + '\n' for p in refs])

    return refs


def createCompletedPlays(n, pids, arbs, rounds, comp_players):

    def getArb(round):
        compId = None
        for r in rounds:
            if r[0] == round:
                compId = r[1]
                break
        return [i[2] for i in arbs if i[1] == compId]

    plays = []
    inds = set(range(n))

    while len(inds):
        for round, comp in rounds:
            if len(inds) == 0:
                break
            elif len(inds) % 1000:
                print(n - len(inds))

            plays.append([str(inds.pop()), choice(['1-0', '0-1', '1/2-1/2']), choice(comp_players[comp]),
                          choice(comp_players[comp]), str(round),
                          str(choice(getArb(round))), str(randint(0, 29999)), str(randint(0, 29999))])

    with open('plays.txt', 'w') as f:
        f.writelines(['\t'.join(p) + '\n' for p in plays])


if __name__ == '__main__':
    createTimes(30000)
    createMoves(30000)
    pids = createPlayers(5000)
    create_Qualifs()
    createRanks()
    create_Fides()

    createArbs(1500)
    createComps(100, [i for i in range(1500)])

    comp_players = createParticipations(6000, pids)
    arbs = createRefereeing(1000)
    nrounds, rounds = createRounds(100)
    createCompletedPlays(nrounds * 30, pids, arbs, rounds, comp_players)
