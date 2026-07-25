# science — 제약·신약개발 Agent Skills 모음

제약 R&D(신약탐색·임상·오믹스·바이오인포매틱스)용으로 선별한 GitHub Agent Skills
저장소 4곳을 이 프로젝트에 설치·구성한 것입니다. 모든 skill은 Claude Code가
`.claude/skills/`에서 자동으로 인식하며, 관련 작업 시 자동 호출됩니다.

설치 기준일: **2026-07-25** · 대상 에이전트: **Claude Code**

## 설치된 skill 구성 (총 747개)

| 출처 | 저장소 | skill 접두어 | 개수 | 라이선스 | 설치 방식 |
|---|---|---|---|---|---|
| K-Dense | `K-Dense-AI/scientific-agent-skills` | (접두어 없음) | 149 | MIT (skill별 상이) | `npx skills add` |
| GPTomics bioSkills | `GPTomics/bioSkills` | `bio-` | 561 | MIT | `install-claude.sh` |
| NVIDIA BioNeMo | `NVIDIA-BioNeMo/bionemo-agent-toolkit` | `*-nim` 등 | 20 | Apache-2.0 / CC-BY-4.0 | `npx skills add` |
| Anthropic Life Sciences | `anthropics/life-sciences` | `anthropic-` | 6 | 각 skill LICENSE.txt | 수동 복사 (파일형) |

> 검증: 위 4개 저장소는 2026-07-25 기준 GitHub에서 실존·star 수까지 대조 확인됨
> (K-Dense 31.7k · bioSkills 1.07k · BioNeMo 393 · life-sciences 547).

### 접두어를 둔 이유
- `bio-` / `anthropic-` 접두어는 **저장소 간 이름 충돌 방지 + 출처 식별**을 위한 것입니다.
  실제로 `scvi-tools`가 K-Dense와 Anthropic 양쪽에 존재해, Anthropic 쪽은
  `anthropic-scvi-tools`로 SKILL.md의 `name` 필드까지 변경했습니다.

## Anthropic Life Sciences — MCP 플러그인 (별도 구성)

Anthropic 저장소에는 파일형 skill 6개 외에, **원격 MCP 서버 연동형 플러그인 15개**
(ChEMBL, Open Targets, ClinicalTrials.gov, PubMed, bioRxiv, Consensus, Cortellis,
AdisInsight, Medidata, Synapse, 10x Genomics, BioRender, Owkin, Wiley 등)가 있습니다.
이들은 파일 복사가 아니라 **플러그인 마켓플레이스**로 연결하며, `.claude/settings.json`에
설정해 두었습니다.

### 기본 활성화 (무료·공개 데이터, 자격증명 불필요)
`.claude/settings.json`의 `enabledPlugins`에서 아래 5개를 활성화했습니다.
- `pubmed` · `biorxiv` · `clinical-trials` · `chembl` · `open-targets`

Claude Code에서 `/reload-plugins`(또는 세션 재시작)로 적용됩니다.

### 유료·자격증명 필요 (수동 설치)
Cortellis, AdisInsight, Medidata, Wiley, Synapse, Owkin, 10x, BioRender 등은
각 제공사 계정/키가 필요합니다. 필요 시:
```
/plugin marketplace add anthropics/life-sciences
/plugin install cortellis@life-sciences      # 예시
/plugin              # → Manage plugins → Configure 로 자격증명 입력
```

## ⚠️ 컨텍스트 비용 주의 (중요)

skill의 `name`+`description`은 **항상 로드**됩니다. 747개 전량 설치 시 상시 오버헤드가
**대략 150K+ 토큰**(bioSkills만 ~109K)에 달해, 실사용 컨텍스트를 크게 잠식하고
응답 품질을 떨어뜨릴 수 있습니다. **본인 업무에 맞게 카테고리를 추려 쓰는 것을 강력히 권장합니다.**

### 불필요한 카테고리 정리 예시
```bash
# bioSkills 특정 카테고리만 남기고 나머지 제거 (재설치 방식)
#   먼저 전체 제거 후, 원하는 카테고리만 재설치
cd /path/to/bioSkills && ./install-claude.sh --project . --uninstall
./install-claude.sh --project . --categories chemoinformatics,clinical-biostatistics,clinical-databases,differential-expression,pathway-analysis

# 개별 skill 폴더 직접 삭제도 가능
rm -rf .claude/skills/bio-ecological-genomics-*
```
제약 R&D 관점에서 우선순위 높은 bioSkills 카테고리: `chemoinformatics`,
`clinical-biostatistics`, `clinical-databases`, `differential-expression`,
`pathway-analysis`, `variant-calling`, `single-cell`, `proteomics`.

## 재설치 / 업데이트

`setup.sh`로 K-Dense·BioNeMo·bioSkills를 재설치할 수 있습니다.
```bash
./setup.sh
```
K-Dense·BioNeMo는 `skills-lock.json`으로 버전이 고정됩니다.

## 라이선스 / 사용 주의
- skill은 **에이전트 전체 권한으로 실행**됩니다. 실행 전 내용을 검토하세요.
- 각 skill의 라이선스는 해당 폴더의 `SKILL.md` 또는 `LICENSE(.txt)`를 따릅니다.
- 저장소 목록·star 수는 홍보성 게시물이 아니라 GitHub API로 직접 검증한 값입니다.
