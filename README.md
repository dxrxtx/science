# science — 제약·신약개발 Agent Skills 모음

제약 R&D(신약탐색·임상·오믹스·바이오인포매틱스)용으로 선별한 GitHub Agent Skills를
이 프로젝트에 설치·구성한 것입니다. 모든 skill은 Claude Code가 `.claude/skills/`에서
자동 인식하며, 관련 작업 시 자동 호출됩니다.

설치 기준일: **2026-07-25** · 대상 에이전트: **Claude Code** · **총 1,837개 skill**

## 설치된 skill 구성

LinkedIn 랭킹 10개 저장소를 실제 설치·검증한 결과, **라이선스가 허용하고 Claude Code
포맷으로 로드되는 9개**를 설치했습니다. (1개 제외 — 아래 참조)

| 랭킹 | 저장소 | 접두어 | 개수 | 라이선스 | 설치 방식 |
|---|---|---|---|---|---|
| 1 | `K-Dense-AI/scientific-agent-skills` | (없음) | 149 | MIT | `npx skills` |
| 3 | `google-deepmind/science-skills` | `gdm-` | 38 | Apache-2.0 | vendor(복사) |
| 4 | `mims-harvard/ToolUniverse` | `tuniv-` | 153 | Apache-2.0 | vendor(복사) |
| 5 | `aipoch/medical-research-skills` | `aipoch-` | 604 | MIT | vendor(복사) |
| 6 | `ClawBio/ClawBio` | `clawbio-` | 95 | MIT | vendor(복사) |
| 7 | `GPTomics/bioSkills` | `bio-` | 561 | MIT | `install-claude.sh` |
| 8 | `bioMate-AI/biomate-bioconductor-kb` | `biomate-` | 200 | CC-BY-4.0 | vendor(복사) |
| 9 | `anthropics/life-sciences` (파일형) | `anthropic-` | 6 | 각 LICENSE | 복사 |
| 10 | `NVIDIA-BioNeMo/bionemo-agent-toolkit` | (없음) | 20 | Apache-2.0/CC-BY-4.0 | `npx skills` |

> 접두어는 **저장소 간 이름 충돌 방지 + 출처 식별**용입니다. vendor 설치 시 각 SKILL.md의
> frontmatter를 `name`(접두어 적용)+`description`으로 **YAML-안전하게 재작성**해,
> 원본에 있던 YAML 문법 오류(미인용 콜론 등)를 모두 정리했습니다.

## ⛔ 제외된 저장소 (1개)

| 랭킹 | 저장소 | 제외 사유 |
|---|---|---|
| 2 | `FreedomIntelligence/OpenClaw-Medical-Skills` | 최상위 라이선스 없음 + 파일별 **"All Rights Reserved / 무단 복제 금지(proprietary)"** 명시. 재배포 시 저작권 침해 → 설치·커밋하지 않음. 또한 **OpenClaw 프레임워크 전용** 포맷이라 `name`/`description` frontmatter가 없어 Claude Code에서 그대로 로드되지도 않음. |

## Anthropic Life Sciences — MCP 플러그인 (별도 구성)

파일형 skill 6개 외에, 원격 MCP 서버 연동형 플러그인 15개(ChEMBL, Open Targets,
ClinicalTrials.gov, PubMed, bioRxiv, Consensus, Cortellis, AdisInsight, Medidata,
Synapse, 10x Genomics, BioRender, Owkin, Wiley 등)는 `.claude/settings.json`에
마켓플레이스로 연결했습니다.

- **기본 활성화(무료·공개, 자격증명 불필요)**: `pubmed` · `biorxiv` · `clinical-trials` · `chembl` · `open-targets` → Claude Code에서 `/reload-plugins`로 적용
- **유료·자격증명 필요**: Cortellis/AdisInsight/Medidata/Wiley/Synapse/Owkin/10x/BioRender → `/plugin install <name>@life-sciences` 후 `/plugin`에서 Configure

## ⚠️ 컨텍스트 비용 주의 (매우 중요)

skill의 `name`+`description`은 **항상 로드**됩니다. **1,837개 전량**은 상시 오버헤드가
**대략 400K+ 토큰**에 달해, 실사용 컨텍스트를 심각하게 잠식하고 응답 품질을 떨어뜨립니다.
**실제 사용 시에는 본인 업무에 맞는 하위 집합만 남기는 것을 강력히 권장합니다.**

정리 예시:
```bash
# 특정 출처 전체 제거
rm -rf .claude/skills/tuniv-*          # ToolUniverse 제거
rm -rf .claude/skills/aipoch-*         # AIPOCH 제거

# bioSkills 특정 카테고리만 제거
rm -rf .claude/skills/bio-ecological-genomics-* .claude/skills/bio-microbiome-*
```
제약 R&D 우선 카테고리: chemoinformatics, ADMET/docking, clinical-biostatistics,
clinical-databases, differential-expression, pathway-analysis, variant-calling,
single-cell, proteomics, structural-biology.

## 용량 관련 참고
vendor 설치 시 일부 저장소에 번들된 **예제 데이터 파일(>1MB, csv/gz/rds 등 28개, 약 428MB)은
제거**했습니다. skill 지침(SKILL.md)과 스크립트는 그대로이므로 기능에는 영향이 없으며,
분석 시에는 사용자 본인 데이터를 사용하면 됩니다.

## 재설치 / 업데이트
```bash
./setup.sh          # 9개 저장소 전체 재설치 (라이선스 허용 범위)
```

## 라이선스 / 사용 주의
- skill은 **에이전트 전체 권한으로 실행**됩니다. 실행 전 내용을 검토하세요.
- 각 skill 라이선스는 위 표 및 해당 폴더의 `SKILL.md`/`LICENSE`를 따릅니다.
  (BioMate 콘텐츠는 CC-BY-4.0 — 출처 표기: **BioMate-KB**)
- 저장소 목록·star 수·설치 가능 여부는 홍보성 게시물이 아니라 **GitHub API + 실제 설치
  테스트로 직접 검증**한 값입니다.
