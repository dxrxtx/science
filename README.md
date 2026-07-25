# science — 제약·신약개발 Agent Skills (Top 10 설치 정리)

제약 R&D(신약탐색·임상·오믹스·바이오인포매틱스)용으로 화제가 된 **GitHub Agent Skills
Top 10 저장소**를 실제로 검증·설치한 결과입니다. 모든 skill은 Claude Code가
`.claude/skills/`에서 자동 인식하며, 관련 작업 시 자동 호출됩니다.

- 검증·설치 기준일: **2026-07-25**
- 대상 에이전트: **Claude Code**
- 총 설치: **2,419개 skill** · **264 MB** · 전 파일 frontmatter 검증 완료(invalid 0)

---

## 📊 Top 10 설치 현황 요약

| 랭킹 | 저장소 | 설치 | 개수 | 접두어 | 라이선스 |
|:--:|---|:--:|:--:|---|---|
| 🥇 1 | `K-Dense-AI/scientific-agent-skills` | ✅ 전체 | 149 | (없음) | MIT |
| 🥈 2 | `FreedomIntelligence/OpenClaw-Medical-Skills` | ⚠️ 부분 | 582 / 896 | `openclaw-` | MIT(부분)¹ |
| 🥉 3 | `google-deepmind/science-skills` | ✅ 전체 | 38 | `gdm-` | Apache-2.0 |
| 4 | `mims-harvard/ToolUniverse` | ✅ 전체 | 153 | `tuniv-` | Apache-2.0 |
| 5 | `aipoch/medical-research-skills` | ✅ 전체 | 604 | `aipoch-` | MIT |
| 6 | `ClawBio/ClawBio` | ✅ 전체 | 95 | `clawbio-` | MIT |
| 7 | `GPTomics/bioSkills` | ✅ 전체 | 561 | `bio-` | MIT |
| 8 | `bioMate-AI/biomate-bioconductor-kb` | ✅ 전체 | 200 | `biomate-` | CC-BY-4.0 |
| 9 | `anthropics/life-sciences` | ✅ 파일형+MCP | 6 (+MCP) | `anthropic-` | 각 LICENSE |
| 10 | `NVIDIA-BioNeMo/bionemo-agent-toolkit` | ✅ 전체 | 31 | (없음) | Apache-2.0 / CC-BY-4.0 |

> **10개 저장소 모두 반영** — 9개는 전체(또는 파일형 전체), OpenClaw만 라이선스상
> 허용되는 부분(582/896)만 설치.

---

## 🔎 저장소별 상세

### 🥇 1. K-Dense Scientific Agent Skills — 149개
신약탐색·ADMET·docking·오믹스 전반. 제약 R&D 종합 커버. 설치: `npx skills`(copy 모드).

### 🥈 2. OpenClaw Medical Skills — 582 / 896개 (부분)
12개+ 저장소를 통합한 **애그리게이터**로 파일마다 라이선스가 다름.
- README는 **MIT 선언**(배지)하나 최상위 `LICENSE` 파일은 **부재**.
- 896개 중 **309개**는 `MD BABU MIA` 저작권의 **"All Rights Reserved / proprietary /
  무단 복제 금지"** → **재배포 불가라 제외**. (이 309개는 HTML 주석 포맷이라 Claude Code
  로드도 안 됨 — 제외 집합과 정확히 일치.)
- 제한 문구 없는 **582개(MIT 범위)만 설치**.
- ¹ 주의: 최상위 LICENSE 부재로 MIT 근거는 저장소 공개 선언에 의존. 582개 중 재번들된
  타 저장소 콘텐츠가 있을 수 있어 **상업적 재배포 전 개별 출처 확인 권장**.

### 🥉 3. Google DeepMind Science Skills — 38개
AlphaFold DB·AlphaGenome·UniProt 등 30+ DB/도구 연동. Genomics·구조생물학.

### 4. Harvard ToolUniverse — 153개
신약 타깃 발굴·정밀종양학 워크플로. (원본 SKILL.md의 YAML 오류를 재작성으로 복구.)

### 5. AIPOCH Medical Research Skills — 604개
문헌검색·임상 protocol·통계·논문작성. 임상개발·의학통계·메디컬라이팅 최대 컬렉션.

### 6. ClawBio — 95개
로컬 실행·재현성 중심 bioinformatics. Pharmacogenomics.

### 7. GPTomics bioSkills — 561개
RNA-seq·single-cell·집단유전학 등 63개 카테고리 표준 오믹스 절차. (전용 설치기 사용.)

### 8. BioMate Bioconductor KB — 200개
DESeq2·edgeR·limma 등 Bioconductor 200패키지 사용법. (YAML 오류 재작성 복구.)

### 9. Anthropic Life Sciences — 파일형 6개 + MCP 15개
- **파일형 skill 6개**: 임상 protocol, Allotrope 변환, Nextflow, scvi-tools 등 → 설치 완료.
- **MCP 플러그인 15개**: `.claude/settings.json`에 마켓플레이스 연결. 무료·공개 5개
  (`pubmed`·`biorxiv`·`clinical-trials`·`chembl`·`open-targets`) 기본 활성화 →
  Claude Code에서 `/reload-plugins`로 적용. 유료(Cortellis·Medidata 등)는
  `/plugin install <name>@life-sciences` 후 Configure.

### 🔟 10. NVIDIA BioNeMo Agent Toolkit — 31개
단백질 구조·docking·생성화학·ADMET·binder design (boltz2, rfdiffusion, diffdock,
proteinmpnn 등). 일부 skill은 `NGC_API_KEY` 필요. 설치: `npx skills`(copy 모드).

---

## ⚠️ 컨텍스트 비용 (매우 중요)

skill의 `name`+`description`은 **항상 로드**됩니다. **2,419개 전량**은 상시 오버헤드가
**대략 530K+ 토큰**에 달해 실사용 컨텍스트를 심각하게 잠식합니다.
**실제 사용 시 본인 업무에 맞는 하위 집합만 남기는 것을 강력히 권장합니다.**

```bash
# 출처 단위 제거
rm -rf .claude/skills/openclaw-*      # OpenClaw 전체 제거
rm -rf .claude/skills/tuniv-*         # ToolUniverse 제거

# bioSkills 특정 카테고리만 제거
rm -rf .claude/skills/bio-ecological-genomics-* .claude/skills/bio-microbiome-*
```
제약 R&D 우선 카테고리: chemoinformatics, ADMET/docking, clinical-biostatistics,
clinical-databases, differential-expression, pathway-analysis, variant-calling,
single-cell, proteomics, structural-biology.

---

## 🛠 구현 참고

- **접두어**: 저장소 간 이름 충돌 방지 + 출처 식별용. vendor 설치 시 각 SKILL.md
  frontmatter를 `name`(접두어)+`description`으로 **YAML-안전하게 재작성**해 원본의
  문법 오류(미인용 콜론 등)를 정리.
- **용량 정리**: 번들 예제 데이터 파일(>1MB, csv/gz/rds 등)은 제거. SKILL.md 지침과
  스크립트는 그대로이며, 분석 시 사용자 데이터를 사용하면 됨.
- **재설치/업데이트**: `./setup.sh` (10개 저장소, 라이선스 허용 범위 전체 재현).
- **재현 스크립트**: `scripts/vendor_skills.py` (frontmatter 정규화 복사기).

## 📌 검증 방법
저장소 실존 여부·star 수·설치 가능성은 홍보성 게시물이 아니라 **GitHub API + 실제 설치·
파싱 테스트**로 직접 검증한 값입니다. (게시물 star 수는 2026-07-15 기준이며, 현재 값은
열흘간의 자연 증가로 조금씩 높아 게시물 수치의 정확성이 확인됨.)

## ⚖️ 사용 주의
- skill은 **에이전트 전체 권한으로 실행**됩니다. 실행 전 내용을 검토하세요.
- 각 skill 라이선스는 위 표 및 해당 폴더의 `SKILL.md`/`LICENSE`를 따릅니다.
  (BioMate 콘텐츠 CC-BY-4.0 — 출처 표기: **BioMate-KB**)
