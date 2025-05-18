import styles from './Footer.module.css';

export default function Footer() {
  return (
    <>
      <div className={styles.footer}>
        <div className={styles.logo}>
          <img src="/images/uon.svg" alt="Logo UoN" />
        </div>
        <div className={styles.logo}>
          <img src="/images/nihr.svg" alt="Logo CCN" />
        </div>
        <div className={styles.logo}>
          <img src="/images/hdr.svg" alt="Logo UKRI" />
        </div>
        <div className={styles.logo}>
          <img src="/images/sde.svg" alt="Logo ALVE" />
        </div>
      </div>
    </>
  );
}